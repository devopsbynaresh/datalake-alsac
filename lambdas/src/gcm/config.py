import io
import json
import os
from pathlib import Path
import shutil
import uuid
import time

import boto3
from botocore.exceptions import ClientError
from googleapiclient import discovery
import httplib2
from oauth2client.service_account import ServiceAccountCredentials

from gcm import download

# The deployment location options
LOCAL = 'Local'
AWS = 'AWS'
DEPLOYED = AWS

# The OAuth 2.0 scopes to request.
OAUTH_SCOPES = ['https://www.googleapis.com/auth/dfareporting']

# Local paths
resources_path = Path('resources')
parameters_path = resources_path / 'parameters'
downloads_path = resources_path / 'downloads'
landing_path = downloads_path / 'landing'
raw_path = downloads_path / 'raw'
curated_path = downloads_path / 'curated'

if DEPLOYED == AWS:
    # AWS Clients and constants
    ENVIRONMENT = os.environ['ENVIRONMENT']

    PARAMETER_STORE_ROOT = os.environ['ROOT_PARAMETER']
    parameter_store = boto3.client('ssm')

    DOWNLOAD_TOPIC_ARN = os.environ['DOWNLOAD_TOPIC_ARN']
    sns = boto3.client('sns')

    RAW_BUCKET_NAME = os.environ['DOWNLOAD_BUCKET']
    CURATED_BUCKET_NAME = os.environ['UPLOAD_BUCKET']
    S3_ROOT_KEY = 'gcm/'
    S3_TEMP_KEY = 'temp/' + S3_ROOT_KEY
    s3 = boto3.client('s3')
    s3_exists_waiter = s3.get_waiter('object_exists')
    s3_not_exists_waiter = s3.get_waiter('object_not_exists')
    s3_list_objects_v2_paginator = s3.get_paginator('list_objects_v2')

    LAMBDA_TEMP_PATH = Path('/tmp')
    LAMBDA_TEMP_LANDING_PATH = LAMBDA_TEMP_PATH / 'landing'
    LAMBDA_TEMP_RAW_PATH = LAMBDA_TEMP_PATH / 'raw'
    LAMBDA_TEMP_CURATED_PATH = LAMBDA_TEMP_PATH / 'curated'


def load_json_parameter(name):
    """Loads a JSON parameter"""
    if DEPLOYED == LOCAL:
        filename = name + '.json'
        path = parameters_path / filename
        if path.exists():
            with open(path, 'r') as data:
                param = json.load(data)
        else:
            param = {}
    elif DEPLOYED == AWS:
        param_name = PARAMETER_STORE_ROOT + name
        try:
            param = parameter_store.get_parameter(
                Name=param_name,
                WithDecryption=True)
            if param:
                param = param.get('Parameter')
                if param:
                    param = param.get('Value')
                    if param:
                        param = json.loads(param)

            if not param:
                param = {}
        except ClientError:
            param = {}
    return param


def save_json_parameter(name, value):
    """Saves a JSON parameter"""
    if DEPLOYED == LOCAL:
        filename = name + '.json'
        path = parameters_path / filename
        ensure_parent_directories(path)
        with open(path, 'w') as data:
            json.dump(value, data)
    elif DEPLOYED == AWS:
        param_name = PARAMETER_STORE_ROOT + name
        current_param = {}
        try:
            # Get parameter value if it already exists
            old_value = parameter_store.get_parameter(Name=param_name)['Parameter']['Value']
            current_param = json.loads(old_value)

            parameter_store.delete_parameter(Name=param_name)
        except ClientError:
            pass

        # Combine old parameter value (if it exists, otherwise empty), and new value
        updated_param = {**current_param, **value}

        # Make sure Date is set to lowercase if we are saving an expected-datatypes parameter
        if 'Date' in updated_param:
            updated_param['date'] = updated_param.pop('Date')

        # Add new parameter to parameter store
        time.sleep(10)  # Wait for 10 seconds to ensure that the Parameter deletion has completed
        parameter_store.put_parameter(
            Name=param_name,
            Value=json.dumps(updated_param),
            Type='String',
            Tags=[
                {'Key': 'Environment', 'Value': ENVIRONMENT},
                {'Key': 'ProjectTeam', 'Value': 'datalake'}
                ])


def authenticate_using_service_account():
    """Authorizes an httplib2.Http instance using service account credentials."""
    # Create the service account credentials.
    json_creds = load_json_parameter('service-account')
    credentials = ServiceAccountCredentials.from_json_keyfile_dict(json_creds, scopes=OAUTH_SCOPES)

    # Use the credentials to authorize an httplib2.Http instance.
    http = credentials.authorize(httplib2.Http())

    return http


def get_dfareporting_service():
    """Builds the DFA Reporting service, authenticating with the service account"""
    # Authenticate using the supplied service account credentials
    http = authenticate_using_service_account()

    # Construct a service object via the discovery service.
    return discovery.build('dfareporting', 'v3.3', http=http, cache_discovery=(DEPLOYED == LOCAL))


def get_dataset_to_report_info():
    """Returns Dataset to Report info to monitor and download upon available"""
    # Sohaib's report ID: 686707795
    return load_json_parameter('report-info')


def save_dataset_to_report_info(dataset_to_report_info):
    """Saves Dataset to Report info for monitoring service"""
    save_json_parameter('report-info', dataset_to_report_info)


def report_already_exists(dataset, raw_filename):
    """Checks if a file has already been downloaded"""
    if DEPLOYED == LOCAL:
        exists = (landing_path / dataset / raw_filename).exists() or (raw_path / dataset / raw_filename).exists()
    elif DEPLOYED == AWS:
        bucket = RAW_BUCKET_NAME
        raw_key = S3_ROOT_KEY + dataset + '/' + raw_filename

        try:
            raw_head = s3.head_object(
                Bucket=bucket,
                Key=raw_key)
        except ClientError:
            raw_head = None

        exists = False
        if raw_head:
            exists = True
        else:
            landing_key = S3_TEMP_KEY + dataset + '/' + raw_filename
            try:
                landing_head = s3.head_object(
                    Bucket=bucket,
                    Key=landing_key)
            except ClientError:
                landing_head = None

            if landing_head:
                exists = True

    return exists


def begin_download(dataset, report_id, file_id, raw_filename):
    """Kicks off the download process for this report file"""
    if DEPLOYED == LOCAL:
        download.download(dataset, report_id, file_id, raw_filename)
    elif DEPLOYED == AWS:
        sns_response = sns.publish(
            TopicArn=DOWNLOAD_TOPIC_ARN,
            Message=json.dumps({
                    'dataset': dataset,
                    'report_id': report_id,
                    'file_id': file_id,
                    'filename': raw_filename
                }))
        print('Invoked SNS for download: ' + str(sns_response))


def ensure_parent_directories(path):
    path.parent.mkdir(parents=True, exist_ok=True)


def get_download_landing_file_path(dataset, filename):
    """Gets the path for the Downloader landing file"""
    if DEPLOYED == LOCAL:
        root = landing_path
    elif DEPLOYED == AWS:
        root = LAMBDA_TEMP_LANDING_PATH

    path = root / dataset / filename
    ensure_parent_directories(path)
    return path


def get_download_landing_file_for_writing(dataset, filename):
    """Gets the target for the Downloader landing file"""
    path = get_download_landing_file_path(dataset, filename)
    return io.FileIO(path, mode='wb')


def get_download_landing_file_for_reading(dataset, filename):
    """Gets the source for the landing file"""
    path = get_download_landing_file_path(dataset, filename)
    return open(path, mode='r')


def delete_download_landing_file(dataset, filename):
    """Deletes the landing file"""
    path = get_download_landing_file_path(dataset, filename)
    if path.exists():
        os.remove(path)


def move_successful_download(dataset, filename):
    """Moves a successful download from temp to raw"""
    # Upload temp/landing to S3/temp
    bucket = RAW_BUCKET_NAME
    landing_key = S3_TEMP_KEY + dataset + '/' + filename
    temp_landing_path = LAMBDA_TEMP_LANDING_PATH / dataset / filename
    s3.upload_file(str(temp_landing_path), bucket, landing_key)
    s3_exists_waiter.wait(Bucket=bucket, Key=landing_key)

    # Move S3/temp to S3/raw
    raw_key = S3_ROOT_KEY + dataset + '/' + filename
    s3.copy_object(
        Bucket=bucket,
        Key=raw_key,
        CopySource={
                'Bucket': bucket,
                'Key': landing_key
            })
    s3_exists_waiter.wait(Bucket=bucket, Key=raw_key)
    s3.delete_object(Bucket=bucket, Key=landing_key)

    # Delete temp/landing file
    os.remove(temp_landing_path)
    return raw_key

def extract_dataset_filename_from_s3_key(key):
    split = key[len(S3_ROOT_KEY):].split('/', 1)
    return (split[0], split[1])


# def save_dataset_types(dataset, types):
#     """Saves Dataset's datatypes"""
#     save_json_parameter(dataset + '-dtypes', types)


# def load_dataset_types(dataset):
#     return load_json_parameter(dataset + '-dtypes')

def get_curated_dataset_path(dataset):
    """Gets the dataset Path for curated data"""
    if DEPLOYED == LOCAL:
        path = curated_path / dataset
        ensure_parent_directories(path)
    elif DEPLOYED == AWS:
        raise ValueError('Curated dataset path does not apply to AWS')
    return path

