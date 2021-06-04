import sys, csv, json, os, boto3, time
from datetime import datetime, timezone, timedelta

# Add helper functions here for different data sources
from facebook_ads import historical_download as fbAds_download
from google_ads import historical_download as GAds_download
from adobe_ad_cloud import historical_download as aac_download

def handler(event, context):
    # Update parameter in parameter store to track last date pulled in case there's a timeout
    ssm = boto3.client('ssm')
    ssm.put_parameter(
            Name=os.environ['DATE_RANGE'],
            Value=json.dumps(event),
            Type='String',
            Overwrite=True)
    
    event_structure = {'files':[]}
    
    # Test event structure should only contain a single key that corresponds to a specific data source.
    if 'fbAds' in event:
        fbad_keys = fbAds_download.main('fbAds')
        event_structure['files'] += fbad_keys
    elif 'GAds' in event:
        gads_keys = GAds_download.main('GAds')
        event_structure['files'] += gads_keys
    elif 'GAdsDISC' in event:
        gadsdisc_keys = GAds_download.main('GAdsDISC')
        event_structure['files'] += gadsdisc_keys
    elif 'GAdsPS' in event:
        gadsps_keys = GAds_download.main('GAdsPS')
        event_structure['files'] += gadsps_keys
    elif 'aac' in event:
        aac_keys = aac_download.main('aac')
        event_structure['files'] += aac_keys
    
    # Invoke Process Lambda once raw files are in S3
    client = boto3.client('lambda')
    payload = json.dumps(event_structure).encode('utf-8')
    response = client.invoke(FunctionName='dla_data_process_all',InvocationType='RequestResponse',Payload=payload)
