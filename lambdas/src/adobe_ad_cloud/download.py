import requests, base64, json, os, csv, boto3
from datetime import date, timedelta

##### GET ALL CAMPAIGNS #####
# Get a map of campaign IDs to campaign names for all campaigns found in the AdCloud account
def get_campaigns(yesterday, token):
    # Request URL calls on campaigns in the time range of 00:00 to 23:59 of the previous day
    url = f'https://api.tubemogul.com/v2/reporting/campaigns?start_day={yesterday}&end_day={yesterday}&timezone=America%2FChicago&limit=1000'
    headers = { 'Authorization': 'Bearer ' + token }
    response = requests.get(url, headers=headers)

    # Data returned from the API is in JSON format
    records = json.loads(response.content)['items']

    # For each campaign, track the unique campaign ID and its corresponding campaign name
    campaigns = {}
    for item in records:
        campaign_id = item['campaign_id']
        campaigns[campaign_id] = item['campaign_name']
    return campaigns

##### GET ALL PLACEMENTS #####
# Get a map of placement IDs to placement names for a given campaign ID
def get_placements(yesterday, campaign_id, token):
    # Request URL calls on all placements for a campaign in the time range of 00:00 to 23:59 of the previous day
    url = f'https://api.tubemogul.com/v2/reporting/campaigns/{campaign_id}/placements?start_day={yesterday}&end_day={yesterday}&timezone=America%2FChicago&limit=1000'
    headers = {'Authorization': 'Bearer ' + token}
    response = requests.get(url, headers=headers)

    # Data returned from the API is in JSON format
    records = json.loads(response.content)['items']

    # A campaign can have multiple placements. For each placement, continue to track the corresponding campaign in addition to the placement ID.
    group = []
    for item in records:
        placement = {}
        placement['campaign_id'] = campaign_id
        placement['campaign_name'] = item['campaign_name']
        placement['placement_id'] = item['placement_id']
        placement['placement_name'] = item['placement_name']
        group.append(placement)
    return group

##### GET ALL ADS #####
# Get ad-level metrics for a given placement
def get_ads(yesterday, placement_id, campaign_name, placement_name, token):
    # Request URL calls on all ads for a placement in the time range of 00:00 to 23:59 of the previous day 
    url = f'https://api.tubemogul.com/v2/reporting/placements/{placement_id}/ads?start_day={yesterday}&end_day={yesterday}&timezone=America%2FChicago&limit=1000'
    headers = {'Authorization': 'Bearer ' + token}
    response = requests.get(url, headers=headers)

    # Data returned from API is in JSON format
    records = json.loads(response.content)['items']
    group = []

    # A placement can have multiple ads. For each ad, continue to track the corresponding campaign and placement in addition to the ad-level metrics.
    for item in records:
        buckets = item['stats']['buckets']
        for b in buckets:
            ad = {}
            ad['placement_name'] = placement_name
            ad['campaign_name'] = campaign_name
            ad['ad_name'] = item['ad_name']
            metrics = b['data']
            # Total net spend = billable total fees
            ad['net_spend_total'] = (metrics['billable_total_fees']) / 1000000
            group.append(ad)
    return group

##### AUTHENTICATE TO API #####
# Get temporary access token in order to use API
def get_auth_token(secret, user_id):
    msg = f'{user_id}:{secret}'
    msg_bytes = msg.encode('utf-8')
    credentials = base64.b64encode(msg_bytes)

    headers = {
        'Authorization': 'Basic ' + str(credentials, 'utf-8'),
        'Cache-Control': 'no-cache',
        'Content-Type': 'application/x-www-form-urlencoded'
    }

    data = {
        'grant_type': 'client_credentials'
    }

    response = requests.post('https://api.tubemogul.com/oauth/token', headers=headers, data=data)

    auth_msg = json.loads(response.content)
    account_id = auth_msg['account_id']
    token = auth_msg['token']
    return account_id, token

##### MAIN FUNCTION #####
def main():
    # Get credentials from SSM Parameter Store
    ssm = boto3.client('ssm')
    credentials = json.loads(ssm.get_parameter(Name=os.environ['ADOBE_AD_CREDENTIALS'],WithDecryption=True)['Parameter']['Value'])
    user_id = credentials['user_id']
    secret = credentials['secret']

    # Get Auth token
    account_id, token = get_auth_token(secret, user_id)

    # Get all campaigns from yesterday
    yesterday = (date.today() - timedelta(days=1)).strftime('%Y-%m-%d')
    campaigns = get_campaigns(yesterday, token)

    # Get all placement IDs for each campaign ID
    placements = [get_placements(yesterday, cid, token) for cid in campaigns]

    # Get all ad data for each placement
    data = []
    for group in placements:
        for item in group:
            ad_group = get_ads(yesterday, item['placement_id'], item['campaign_name'], item['placement_name'], token)
            for ad in ad_group:
                row = [yesterday, ad['campaign_name'], ad['placement_name'], ad['ad_name'], 'TBD', ad['net_spend_total']]
                data.append(row)
 
    # Write to CSV file
    filename = yesterday + '.csv'
    header = ['date', 'campaign name', 'placement name', 'ad name', 'hardware', 'total net spend']
    with open('/tmp/' + filename, 'w', newline='', encoding='utf-8', errors='ignore') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        writer.writerows(data)
    adobe_file = upload_to_s3('/tmp/' + filename)
    return adobe_file
    
##### UPLOAD CSV TO S3 #####
# Grabs CSV file from temporary storage and uploads to the correct prefix in an S3 bucket
def upload_to_s3(filepath):
    s3 = boto3.resource('s3')
    bucket_name = os.environ['DOWNLOAD_BUCKET']
    bucket = s3.Bucket(bucket_name)
    folder = 'platform_performance_daily'
    new_path = filepath.replace('/tmp/','/')
    bucket.upload_file(filepath, 'aac/' + folder + new_path)
    print(f'Uploaded {filepath} to {bucket_name}/aac/{folder}')
    return 'aac/' + folder + new_path
