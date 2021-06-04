import sys, csv, json, os, boto3
from datetime import datetime, timezone, timedelta
from facebook_business.api import FacebookAdsApi
from facebook_business.adobjects.adaccount import AdAccount
from facebook_business.adobjects.campaign import Campaign
from facebook_business.adobjects.adsinsights import AdsInsights
    
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

    # Write data to CSV file        
    with open('/tmp/' + filename, 'w', newline='', encoding='utf-8', errors='ignore') as file:
        writer = csv.writer(file)
        writer.writerow(["date"] + headers)
        writer.writerows(data)

    # Upload CSV file to S3
    s3 = boto3.resource('s3')
    bucket_name = os.environ['DOWNLOAD_BUCKET']
    bucket = s3.Bucket(bucket_name)
    bucket.upload_file('/tmp/' + filename, 'fbAds/platform_performance_daily/' + filename)
    print(f'Uploaded /tmp/{filename} to {bucket_name}/fbAds/platform_performance_daily')
    return f'fbAds/platform_performance_daily/{filename}'

# Main function    
def main():
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

    # Grab reports from Facebook Ads
    input_params = json.loads(ssm.get_parameter(Name=os.environ['FBAD_PARAMS'])['Parameter']['Value'])
    input_fields = ssm.get_parameter(Name=os.environ['FBAD_FIELDS'])['Parameter']['Value'].split(",")
    reports = get_all_reports(account, input_params, input_fields)

    # Upload reports to S3 bucket
    end_date = datetime.now(timezone.utc)
    start_date = end_date - timedelta(days=1)
    filename = start_date.strftime("%Y-%m-%d") + "_" + end_date.strftime("%Y-%m-%d") + ".csv"
    s3_key = download(reports, filename, input_params, input_fields)
    return s3_key

