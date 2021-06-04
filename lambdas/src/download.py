import sys, csv, json, os, boto3
from datetime import datetime, timezone, timedelta

# Import helper functions here for specific data sources as needed
from facebook_ads import download as fbad_download
from google_ads import download as gads_download
from gcm import download as gcm_download
from adobe_ad_cloud import download as aac_download

# Invoke Athena Partition Loader Lambda function once Parquet files are in structured bucket
def invoke_process(filenames):
    event_structure = {}
    event_structure['files'] = filenames
    client = boto3.client('lambda')
    payload = json.dumps(event_structure).encode('utf-8')
    response = client.invoke(FunctionName='dla_data_process_all',InvocationType='RequestResponse',Payload=payload)

# Lambda handler
def handler(event, context):
    if 'Records' in event and 'Sns' in event['Records'][0]:
        # Download raw GCM files to S3 and invoke Process Lambda
        gcm_keys = gcm_download.main(event)
        invoke_process(gcm_keys)
    else:
        # Download raw Google Ads files to S3 and invoke Process Lambda
        gads_keys = gads_download.main()
        invoke_process(gads_keys)
        
        # Download raw Facebook Ads files to S3 and invoke Process Lambda
        fbad_key = fbad_download.main()
        invoke_process([fbad_key]) # Right now there's only one FbAds file

        # Download raw Adobe AdCloud files to S3 and invoke Process Lambda
        aac_key = aac_download.main()
        invoke_process([aac_key]) # Right now there's only one AAC file

