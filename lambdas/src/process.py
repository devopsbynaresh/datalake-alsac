import argparse, sys, json, os, boto3, botocore
from datetime import datetime, timedelta
import pandas as pd
from os import path
import time

# Import helper process functions here as new data sources are added
from gcm import process as gcm_process
from google_ads import process as gads_process

PARTITION_NAME = 'date'

##### LOAD PARTITION METADATA INTO GLUE TABLES #####
# Run MSCK REPAIR on table once data is compressed and uploaded to structured bucket
def repair_table(s3_location, db, table, output_location):
    client = boto3.client('lambda')
    info = {
        's3_location': s3_location,
        'database': db,
        'table': table,
        'output_location': output_location
    }
    payload = json.dumps(info).encode('utf-8')
    print('Loading partitions in table')
    response = client.invoke(FunctionName='dla_athena_load_partitions',InvocationType='RequestResponse',Payload=payload)
    print('Partitions loaded.')

##### DOWNLOAD AND COMPRESS CSV FILE LOCALLY #####
def download_and_convert(in_bucket, prefix):
    if 'gcm' in prefix:
        gcm_process.main(in_bucket, prefix)
        return

    s3 = boto3.client('s3')
    landing = '/tmp/temp.csv'
    s3.download_file(in_bucket, prefix, landing)
    print(f'Downloaded s3://{in_bucket}/{prefix} to {landing}')

    # For manual GAdsDISC uploads, need to clean up file and re-encode
    if 'GAdsDISC' in prefix:
        landing = gads_process.clean_disc(landing)

    # Convert raw CSV file into Parquet files
    df = pd.read_csv(landing)
    df.to_parquet(path='/tmp/output', engine='pyarrow', partition_cols=[PARTITION_NAME], compression='Snappy')
    print(f'Compressed {landing} into Parquet partitions under /tmp/output')

##### UPLOAD PARQUET FILES #####
def upload_file(out_bucket, prefix):
    s3 = boto3.resource('s3')
    upload_bucket = s3.Bucket(out_bucket)
    for root,dirs,files in os.walk('/tmp/output'):
        for f in files:
            path = os.path.join(root,f)
            folders = path.split('/')
            partition_name = path.split('/')[3]
            upload_bucket.upload_file(path, prefix + partition_name + '/processed.parquet')
            print(f'Uploaded {path} to s3://{out_bucket}/{prefix}/{partition_name}/processed.parquet')
            os.remove(path)
            print(f'Removed {path} after upload to S3')

##### LAMBDA HANDLER #####
def handler(event, context):
    upload_bucket = os.environ['UPLOAD_BUCKET']
    athena_bucket = os.environ['ATHENA_BUCKET']
    in_bucket = os.environ['DOWNLOAD_BUCKET']
    db = os.environ['DATABASE']

    # GAdsDISC is the only data source relying on s3 bucket notifications
    if 'Records' in event:
        s3_key = event['Records'][0]['s3']['object']['key']
        keys = s3_key.split('/')
        source = keys[0]
        dataset = keys[1]
        print(f'source and dataset are {source}/{dataset}')

        # Download and compress csv file locally
        download_and_convert(in_bucket, s3_key)

        # Upload Parquet files to bucket
        upload_file(upload_bucket, f'{source}/{dataset}/')

        # Run Athena query to load new partitions into table if there are any
        table = os.environ['GADSDISC_TABLE']
        s3_location = f's3://{upload_bucket}/{source}/{dataset}/'
        output_location = f's3://{athena_bucket}/{source}/{dataset}/'
        repair_table(s3_location, db, table, output_location)
        return

    # Raw files from the other data sources can just be passed directly into this Lambda function from the event
    files = event['files'] 
    for f in files:
        s3_key = f
        keys = s3_key.split('/')
        source = keys[0]
        dataset = keys[1]
    
        print(f'Source and dataset are {source}/{dataset}')

        # Get Glue table name for data source to pass to Athena Lambda function later
        if 'fbAd' in s3_key:
            table = os.environ['FBAD_TABLE']
        elif 'gcm/platform_performance_daily' in s3_key:
            table = os.environ['GCM_STANDARD_TABLE']
        elif 'gcm/gcm_daily_floodlight' in s3_key:
            table = os.environ['GCM_FLOODLIGHT_TABLE']
        elif 'gcm/sa360_cost_response_daily' in s3_key:
            table = os.environ['GCM_SA360_COST_RESPONSE_TABLE']
        elif 'gcm/sa360_transactions_daily' in s3_key:
            table = os.environ['GCM_SA360_TRANSACTIONS_TABLE']           
        elif 'GAdsPS' in s3_key:
            table = os.environ['GADSPS_TABLE']
        elif 'GAds' in s3_key:
            table = os.environ['GADS_TABLE']
        elif 'aac' in s3_key:
            table = os.environ['AADS_TABLE']
 
        # Download and compress csv file locally
        download_and_convert(in_bucket, s3_key)
        
        # Upload Parquet files to bucket
        upload_file(upload_bucket, f'{source}/{dataset}/')
    
        # Run Athena query to load new partitions into table if there are any
        s3_location = f's3://{upload_bucket}/{source}/{dataset}/'
        output_location = f's3://{athena_bucket}/{source}/{dataset}/'
        repair_table(s3_location, db, table, output_location)
