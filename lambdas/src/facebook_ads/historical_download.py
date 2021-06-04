import sys, csv, json, os, boto3, time
from datetime import datetime, timezone, timedelta
from facebook_business.api import FacebookAdsApi
from facebook_business.adobjects.adaccount import AdAccount
from facebook_business.adobjects.campaign import Campaign
from facebook_business.adobjects.adsinsights import AdsInsights

START = ""
STOP = ""

# Grab data based on input parameters and fields for all Ad Sets in the Ad Account
def get_all_reports(account, input_params, input_fields):
    return account.get_insights(
        params=input_params,
        fields=list(map(lambda field : getattr(AdsInsights.Field, field), input_fields))
        )

# Download all reports and save as a .CSV file to an S3 bucket
def download(reports, filename, input_params, input_fields):
    # Create column headers based on input parameters and fields
    headers = input_fields + [x.strip(' ') for x in input_params['breakdowns'].split(",")]

    data = []
    for report in reports:
        row = [report["date_start"]]
        for col in headers:
            row.append(report[col])
        data.append(row)

    # Write to CSV file
    with open('/tmp/' + filename, 'w', newline='', encoding='utf-8', errors='ignore') as file:
        writer = csv.writer(file)
        writer.writerow(["date"] + headers)
        writer.writerows(data)

    # Upload CSV file to S3
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(os.environ['DOWNLOAD_BUCKET'])
    bucket.upload_file('/tmp/' + filename, 'fbAds/platform_performance_daily/' + filename)
    return f'fbAds/platform_performance_daily/{filename}'

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

    all_dates = []
    # Break date range into 4-day chunks for historical load due to API rate limiting
    for single_date in [d for d in (start_date + timedelta(n) for n in range(0,day_count,5)) if d <= end_date]:
        start = single_date
        end = single_date + timedelta(days=4)
        if end > end_date:
            end = end_date
        all_dates.append((start.strftime("%Y-%m-%d"), end.strftime("%Y-%m-%d")))
    return all_dates

# Main function
def main(dataset):
    # Get credentials from Parameter Store
    ssm = boto3.client('ssm')
    credentials = json.loads(ssm.get_parameter(Name=os.environ['FBAD_CREDENTIALS'],WithDecryption=True)['Parameter']['Value'])
    app_id = credentials['app-id']
    app_secret = credentials['app_secret']
    access_token = credentials['access-token']
    account_id = credentials['account-id']

    # Connect to API with credentials
    FacebookAdsApi.init(app_id, app_secret, access_token)
    account = AdAccount(account_id)
    input_params = json.loads(ssm.get_parameter(Name=os.environ['FBAD_PARAMS'])['Parameter']['Value'])
    input_fields = ssm.get_parameter(Name=os.environ['FBAD_FIELDS'])['Parameter']['Value'].split(",")

    # Get all dates
    all_dates = get_all_dates(dataset)

    # Loop through each date tuple in list of dates and pull data to S3
    files = []
    for date_range in all_dates:
        # Keep track of last date range pulled in case API limit is reached
        last_range = {
            'fbAds' : {
                'start': date_range[0],
                'stop': STOP
            }
        }
        # For each date range chunk, keep track of last date pulled in case API limit is reached
        # or Lambda function times out
        ssm.put_parameter(
            Name=os.environ['DATE_RANGE'],
            Value=json.dumps(last_range),
            Type='String',
            Overwrite=True)
            
        week_params = input_params
        week_params['time_range'] = {'since': date_range[0], 'until': date_range[1]}

        # Get all report data for the given date range chunk
        reports = get_all_reports(account, week_params, input_fields)

        # Download file to S3
        filename = date_range[0] + "_" + date_range[1] + ".csv"
        s3_key = download(reports, filename, input_params, input_fields)
        print("Downloaded data for", date_range[0], "to", date_range[1])
        files.append(s3_key)
        if date_range[1] != STOP:
            time.sleep(10)
    return files

