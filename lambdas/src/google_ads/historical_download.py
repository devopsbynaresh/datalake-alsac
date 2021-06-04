import argparse, sys, csv, json, os, boto3
from google.ads.google_ads.client import GoogleAdsClient
from google.ads.google_ads.errors import GoogleAdsException
from datetime import date, timedelta, datetime

# Keep track of which keys correspond to which reports
report_names = {
    'GAds' : 'FY_20_ALL_Campaigns',
    'GAdsPS' : 'PaidSearch_Weekly_for_PM',
    'GAdsDISC' : 'FY_20_ALL_Campaigns_Discovery'
}

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

# Get all dates within historical range specified
def get_all_dates(dataset):
    # Get start and stop dates from Parameter Store
    ssm = boto3.client('ssm')
    param = ssm.get_parameter(Name=os.environ['DATE_RANGE'],WithDecryption=False)['Parameter']['Value']
    json_acceptable_string = param.replace("'", "\"")
    date_range = json.loads(json_acceptable_string)[dataset]
    START = date_range['start']
    STOP = date_range['stop']
    
    # Validate that start and stop dates are not in the future
    if START == "" or STOP == "":
        exit("At least one date field is missing. Please fix historic-date-range parameter and re-run.")
    today = datetime.now()
    start_date = datetime.strptime(START, '%Y-%m-%d')
    end_date = datetime.strptime(STOP, '%Y-%m-%d')
    if start_date < datetime.strptime('2004','%Y') or end_date < datetime.strptime('2004','%Y'):
        exit("Start or stop date is too far back.")
    elif start_date > today:
        exit("Start date %s is in the future!" % START)
    elif end_date > today:
        exit("End date %s is in the future!" % STOP)
    elif start_date > end_date:
        exit("Start date %s is greater than the stop date %s!" % (START, STOP))
 
    # Get date range
    day_count = (end_date - start_date).days + 1

    # Create a list of single dates that cover the whole date range
    all_dates = []
    for single_date in (start_date + timedelta(n) for n in range(day_count)):
        all_dates.append(single_date.strftime("%Y-%m-%d"))
    return all_dates
    
##### DOWNLOAD REPORT FROM GOOGLE ADS #####
# This calls the Google Ads API Client and runs an AWQL query to grab the
# desired fields
def download_report(client, report_name, customer_id, query, header, single_date):
    ga_service = client.get_service('GoogleAdsService', version='v4')

    # Issues a search request using streaming.
    response = ga_service.search_stream(customer_id, query=query)
  
    # Collect rows of data to prepare for writing to CSV 
    rows = [] 
    try:
        for batch in response:
            for row in batch.results:
                _row = [
                    single_date,
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
    filename = f'{report_name}_{single_date}.csv'
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
    bucket.upload_file(filepath, 'google_ads/' + folder + filepath.replace('/tmp/','/'))
    print(f'Uploaded {filepath} to {bucket_name}/google_ads/{folder}')
    return 'google_ads/' + folder + new_path

##### MAIN FUNCTION #####
# Initializes Google Ads client and Boto3 SSM client to grab relevant data from Google Ads
def main(dataset):
    # Get report name
    report = report_names[dataset]

    # Get credentials from SSM Parameter Store
    ssm = boto3.client('ssm')
    credentials = json.loads(ssm.get_parameter(Name=os.environ['GAD_CREDENTIALS'],WithDecryption=True)['Parameter']['Value'])

    # Initiate Google Ads API client with the credentials
    google_ads_client = GoogleAdsClient.load_from_dict(credentials)
    report_ids = json.loads(ssm.get_parameter(Name=os.environ['GAD_REPORTS'],WithDecryption=True)['Parameter']['Value'])
    all_dates = get_all_dates(dataset)
    
    customer_id = report_ids[report]
    template_query = os.environ[report + '_QUERY']
    
    s3_files = []
    # Loop through every single date in the given date range and generate a report for the date
    for single_date in all_dates:
        # Template query will be concatenated with the single date
        query = f'{template_query} "{single_date}"'

        # Extract the column names from the fields in the query
        sub = query[query.find('SELECT')+len('SELECT') : query.find('FROM')].split(',')
        header = ['date'] + [(lambda x : x[0].strip() if 'name' in x else x[1].strip())(field.split('.')) for field in sub]

        # Construct CSV file locally and upload to S3
        path = download_report(google_ads_client, report, customer_id, query, header, single_date)
        s3_key = upload_to_s3(path)

        # Keep track of all locations that raw files are uploaded to
        s3_files.append(s3_key)
    return s3_files
