import argparse, sys, csv, json, os, boto3
from google.ads.google_ads.client import GoogleAdsClient
from google.ads.google_ads.errors import GoogleAdsException
from datetime import date, timedelta

# Taken from googleads protobuf enums for device_pb2
device_enum = {
    0 : 'Unspecified',
    1 : 'Unknown',
    2 : 'Mobile',
    3 : 'Tablet',
    4 : 'Desktop',
    6 : 'Connected_TV',
    5 : 'Other'
}

##### DOWNLOAD REPORT FROM GOOGLE ADS #####
# This calls the Google Ads API Client and runs an AWQL query to grab the
# desired fields
def download_report(client, report_name, customer_id, query, header):
    ga_service = client.get_service('GoogleAdsService', version='v4')
    yesterday = date.today() - timedelta(days = 1)

    # Issues a search request using streaming.
    response = ga_service.search_stream(customer_id, query=query)
  
    # Collect rows of data to prepare for writing to CSV 
    rows = [] 
    try:
        for batch in response:
            for row in batch.results:
                _row = [
                    yesterday.strftime('%Y-%m-%d'),
                    row.campaign.name.value,
                    row.ad_group.name.value,
                    device_enum[row.segments.device]
                ]
                if 'Discovery' in report_name: # NOTE: not being used right now because Google Ads API doesn't support Discovery campaigns
                    _row.append(row.metrics.impressions.value)
                elif 'PaidSearch' in report_name:
                    _row.append(row.metrics.cost_micros.value / 1000000)
                    _row.append(row.metrics.impressions.value)
                else:
                    _row.append(row.metrics.cost_micros.value / 1000000)
                rows.append(_row)
    except GoogleAdsException as ex:
        print(f'Request with ID "{ex.request_id}" failed with status '
              f'"{ex.error.code().name}" and includes the following errors:')
        for error in ex.failure.errors:
            print(f'\tError with message "{error.message}".')
            if error.location:
                for field_path_element in error.location.field_path_elements:
                    print(f'\t\tOn field: {field_path_element.field_name}')
        sys.exit(1)

    # Write to CSV file
    filename = f'{report_name}_{yesterday}.csv'
    with open('/tmp/' + filename, 'w', newline='', encoding='utf-8', errors='ignore') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        writer.writerows(rows)
    return '/tmp/' + filename

##### UPLOAD CSV TO S3 #####
# Grabs CSV file from temporary storage and uploads to the correct prefix in an S3 bucket
def upload_to_s3(filepath):
    s3 = boto3.resource('s3')
    bucket_name = os.environ['DOWNLOAD_BUCKET']
    bucket = s3.Bucket(bucket_name)
    folder = 'GAds'
    if 'Discovery' in filepath: # NOTE: not using right now because of manual raw file uploads
        folder = 'GAdsDISC'
    elif 'PaidSearch' in filepath:
        folder = 'GAdsPS'
    new_path = filepath.replace('/tmp/','/')
    bucket.upload_file(filepath, 'google_ads/' + folder + new_path)
    print(f'Uploaded {filepath} to {bucket_name}/google_ads/{folder}')
    return 'google_ads/' + folder + new_path

##### MAIN FUNCTION #####
# Initializes Google Ads client and Boto3 SSM client to grab relevant data from Google Ads
def main():
    # Get credentials from SSM Parameter Store
    ssm = boto3.client('ssm')
    credentials = json.loads(ssm.get_parameter(Name=os.environ['GAD_CREDENTIALS'],WithDecryption=True)['Parameter']['Value'])
    
    # Initiate Google Ads API client with the credentials
    google_ads_client = GoogleAdsClient.load_from_dict(credentials)
    report_ids = json.loads(ssm.get_parameter(Name=os.environ['GAD_REPORTS'],WithDecryption=True)['Parameter']['Value'])

    s3_files = []
    # For each report in the list of reports from Parameter Store, run the approprate query to get data
    for _id in report_ids:
        customer_id = report_ids[_id]

        # Each query will have the report name as the prefix
        query = os.environ[_id+'_QUERY']

        # Extract the column names from the fields in the query
        sub = query[query.find('SELECT')+len('SELECT') : query.find('FROM')].split(',')
        header = ['date'] + [(lambda x : x[0].strip() if 'name' in x else x[1].strip())(field.split('.')) for field in sub]

        # Construct CSV file locally and upload to S3
        path = download_report(google_ads_client, _id, customer_id, query, header)
        s3_key = upload_to_s3(path)

        # Keep track of all locations that raw files are uploaded to
        s3_files.append(s3_key)
    return s3_files
