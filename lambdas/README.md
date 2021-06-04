# Data Lake Lambda Code

This folder contains all the source code for the Lambda functions in the data lake. The Lambda functions are broken down into download, process, helper functions, and overall governance.

## Data Pipeline

The data pipeline consists of automated and manually triggered Lambda functions.

#### Automated

* **dla_gcm_data_monitor:** The GCM data source is different from the other data sources due to how their reporting structure is set up. This monitors GCM for new reports every hour, and it will trigger the Download Lambda function when a new report is completely available.
* **dla_data_download_all:** This downloads reports from the following external data sources:
    * Google Campaign Manager - standard and floodlight reports
    * Facebook Ads
    * Adobe Advertising Cloud
    * Google Ads - Display Account, Display Account (Discovery), and PaidSearch
* **dla_data_process_all:** This compresses the downloaded reports into Parquet files
* **dla_athena_load_partitions:** This loads the metadata of the partitioned Parquet files into Glue tables for Athena to query.

#### Manual

* **dla_gcm_data_extract:** Due to how the GCM data source is set up, this function helps setup the reports to be ingested in AWS. For additional info, see [GCM_Data_Extractor](GCM_Data_Extractor.md).
* **dla_data_historical_download_all:** This can be used to pull historical data for Google Ads, Facebook Ads, and Adobe AdCloud. Unlike GCM, which automatically pulls historical data starting from July 2019, a date range must be provided in order to pull historical data from the other data sources.

### Parameters

The Lambda functions rely on a set of parameters in order to authenticate against the APIs for the external data sources as well as configure the ingested reports. The following parameters must be **MANUALLY** created.

#### Google Ads

<table>
<tr><th>Parameter Name</th><th>Type</th><th>Expected Value Format (Default)</th><th>Notes</th></tr>

<tr>
<td>/data-lake/data-extractor/google-ads/report-info</td>
<td>SecureString</td>
<td>
<pre>
{
"PaidSearch_Weekly_for_PM" : "GOOGLE ADS CUSTOMER ID",
"FY_20_ALL_Campaigns" : "GOOGLE ADS CUSTOMER ID",
"FY_20_ALL_Campaigns_Discovery" : "GOOGLE ADS CUSTOMER ID"
}
</pre>
</td>
<td>
The Customer ID identifies your Google Ads account.
</td>
</tr>

<tr>
<td>/data-lake/data-extractor/google-ads/service-account</td>
<td>SecureString</td>
<td>
<pre>
{
"developer_token" : "GOOGLE ADS DEVELOPER TOKEN",
"client_id" : "GOOGLE ADS CLIENT ID",
"refresh_token" : "GOOGLE ADS REFRESH TOKEN",
"client_secret" : "GOOGLE ADS CLIENT_SECRET",
"login_customer_id" : "GOOGLE ADS CUSTOMER ID"
}
</pre>
</td>
<td>
To find the developer token, client ID, refresh token, and client secret, please refer to the <a href="https://developers.google.com/google-ads/api/docs/first-call/overview">Google Ads API documentation</a>. The customer ID here should be the ID of the manager account.
</td>
</tr>
</table>

#### Facebook Ads

<table>
<tr><th>Parameter Name</th><th>Type</th><th>Expected Value Format (Default)</th><th>Notes</th></tr>

<tr>
<td>/data-lake/data-extractor/fbAds/fields</td>
<td>StringList</td>
<td>
<pre>
adset_name, campaign_name, spend, impressions, clicks, inline_link_clicks
</pre>
</td>
<td>
This is a list of fields to include in the API response, which will become the column names. For more information on what fields are available, see the <a href="https://developers.facebook.com/docs/marketing-api/insights/parameters/v7.0">API documentation on fields/parameters</a>.
</td>
</tr>

<tr>
<td>/data-lake/data-extractor/fbAds/params</td>
<td>String</td>
<td>
<pre>
{
"action_attribution_windows" : ["1d_view", "7d_click"], 
"breakdowns": "device_platform, publisher_platform", 
"date_preset" : "yesterday",
"level" : "adset",
"time_increment" : 1
}
</pre>
</td>
<td>
This is a JSON string of parameters to include in the API response, which will determine the level and date range of data returned. For more information on what fields are available, see the <a href="https://developers.facebook.com/docs/marketing-api/insights/parameters/v7.0">API documentation on fields/parameters</a>.
</td>
</tr>

<tr>
<td>/data-lake/data-extractor/fbAds/service-account</td>
<td>SecureString</td>
<td>
<pre>
{
"access-token" : "FACEBOOK ADS ACCESS TOKEN",
"account-id" : "FACEBOOK ADS ACCOUNT ID",
"app-id" : "FACEBOOK ADS APP ID",
"app_secret" : "FACEBOOK ADS APP SECRET"
}
</pre>
</td>
<td>
To find the access token, account ID, app ID, and app secret, please refer to <a href="https://developers.facebook.com/docs/marketing-api/access/">API documentation on authentication</a>.
</td>
</tr>
</table>

#### Google Campaign Manager
<table>
<tr><th>Parameter Name</th><th>Type</th><th>Expected Value Format (Default)</th><th>Notes</th></tr>

<tr>
<td>/data-lake/data-extractor/gcm/service-account</td>
<td>SecureString</td>
<td>
<pre>
{
"type" : "service_account",
"project_id" : "GCM PROJECT ID",
"private_key_id" : "GCM PRIVATE KEY ID",
"private_key" : "GCM PRIVATE KEY",
"client_email" : "GSERVICEACCOUNT EMAIL",
"client_id" : "GCM CLIENT ID",
"auth_uri" : "https://accounts.google.com/o/oauth2/auth",
"token_uri" : "https://oauth2.googleapis.com/token",
"auth_provider_x509_cert_url" : "https://www.googleapis.com/oauth2/v1/certs",
"client_x509_cert_url" : "GCM CLIENT CERTIFICATE URL"
}
</pre>
</td>
<td>
</td>
</tr>
</table>

#### Adobe Advertising Cloud
<table>
<tr><th>Parameter Name</th><th>Type</th><th>Expected Value Format (Default)</th><th>Notes</th></tr>

<tr>
<td>/data-lake/data-extractor/adobe-ad-cloud/service-account</td>
<td>SecureString</td>
<td>
<pre>
{
"user_id" : "ADOBE USER ID",
"secret" : "ADOBE API SECRET"
}
</pre>
</td>
<td>
Contact your Adobe AdCloud representative to get the User ID and API secret.
</tr>
</table>

### How to Test Each Lambda Function

To manually test the Lambda functions in the AWS environment, you can set up test events in the Lambda console. To test each of the following Lambda functions manually:

* **dla_gcm_data_monitor:** Create a test event from the CloudWatch template. The JSON object can be left as is.
* **dla_data_download_all:** For GCM, delete the previous day's raw file in the S3 raw bucket, then re-run `dla_gcm_data_monitor`. The monitor function will see that the raw file is missing, so it will send an SNS notification to `dla_data_download_all` to download the raw file. For the other data sources, you can create a test event from the CloudWatch template and use the default JSON.
* **dla_data_process_all:** For all data sources, create a test event with the following structure, where the S3 prefix corresponds to the raw file location in the S3 bucket. An example prefix would be `google_ads/gAdsDISC/report.csv`.
```
{
    "files" : [
        "S3 prefix of raw file 1",
        "S3 prefix of raw file 2",
        ...
    ]
}
```
* **dla_athena_load_partitions:** For all data sources, create a test event with the following structure, where the S3 location is the S3 structured bucket, the database and table are the names of the Glue database and table (specific to data source), and the output location is the S3 Athena results bucket.
```
{
    "s3_location" : "alsac-dev-dla-structured",
    "database" : "performance_marketing_digital_media",
    "table" : "gads_platform_performance_daily",
    "output_location" : "alsac-dev-dla-aws-athena-query-results"
}
```
* **dla_gcm_data_extract:** Assuming that a report already exists on the GCM, create the following test event:
```
{
    "dataset" : "name of dataset",
    "report_id" : "GCM report ID"
}
```
* **dla_data_historical_download_all:** Create a test event with the following structure, where the first key is the abbreviation for the data source (fbAds = Facebook Ads, GAds = Google Ads Display, GAdsDISC = Google Ads Discovery, GAdsPS = Google Ads PaidSearch, aac = Adobe AdCloud):
```
{
    "fbAds" : {
        "start" : "YYYY-MM-DD",
        "stop" : "YYYY-MM-DD"
    }
}
```

### Design Patterns

In AWS, a modular design approach was taken, where a single Lambda function is used to download all data from the data sources, and another single Lambda function was used to convert all incoming raw data into Parquet partitions.

This can be seen in Terraform, but the Download amd Historical Lambda functions' folder structures should look like:
```
├── main_file.py
├── google_ads/
|   └── helper_file.py     (contains helper code specific to Google Ads API)
├── gcm/
|    └── helper_file.py    (contains helper code specific to GCM API)
├── facebook_ads/
|    └── helper_file.py    (contains helper code specific to Facebook Ads API)
├── adobe_ad_cloud/
|    └── helper_file.py    (contains helper code specific to Adobe AdCloud API)
```

The root `download.py` and `historical_download.py` files call on the `download.py` and `historical_download.py` files for the respective data sources every time it receives an event trigger. GCM is triggered by an SNS notification, while the rest of the data sources are triggered by a daily scheduled CloudWatch Event.

The Process Lambda is more generic because it is only converting raw files into Parquet files. However, it does use some helper functions for GCM and Google Ads Discovery data due Google API limitations.

### Limitations

A few limitations were encountered when using the APIs for the following data sources:

* **Facebook Ads API**
  * Facebook Ads has a very low API rate limit, so the historical load for Facebook Ads must be done in small increments. Using a large date range (e.g. more than a couple months) will hit the API limit. Once the API limit is reached, you will need to wait about an hour to call the API again.
* **Google Ads API**
  * The API currently does not support Discovery Campaigns. As a workaround, a user in the **ENV-sl_analyst_role** IAM role must manually upload Discovery reports exported from the Google Ads console to the appropriate S3 location (s3://alsac-<env>-dla-raw/google_ads/GAdsDISC/). This will create an S3 bucket notification that will trigger the Process Lambda specifically for files in the GAdsDISC folder.
* **Adobe AdCloud API**
  * To recreate most of the report structure that is seen in AdCloud, multiple API calls must be used to match fields on the same level of granularity.
  * The API does not allow you to fetch device types at the ad-level, only the placement-level. This will cause the data from the API to not match with the data in the AdCloud console perfectly, so some validation must occur to ensure the campaign names, ad names, and total net spend numbers are correct.

## Governance

Additional Lambda functions were included to assist with governance and monitoring of the data lake. They have their separate READMEs:

* [AWS Account Access Reporting](aws_access_reporting/README.md)
* [S3 Access Reporting](s3_access_reporting/README.md)
* [Daily Parameter Backup](backup_parameters/README.md)

## Library Dependences

Some of these APIs require additional Python libraries for development. These dependences can be uploaded to AWS and attached to your Lambda functions as Lambda Layers. AWS Lambda runs in an Amazon Linux environment, so make sure that the libraries you are using are compatible with the OS. One way to do this is to use Lambda Docker image to simulate the live Lambda environment.

In each data source folder (under `./src`), there is a `requirements.txt` file that you can modify. You can run the following commands in each folder to download the libraries and package them into Lambda Layer .zip files.

1. Create the appropriate directory structure:
```
├── requirements.txt
└── python/
    └── lib/
        └── python3.8/
            └── site-packages/
```

2. Then run the following commands to install the required libraries.
```bash
$ docker run -v "$PWD":/var/task "lambci/lambda:build-python3.8" /bin/sh -c "pip install -r requirements.txt -t python/lib/python3.8/site-packages/; exit"
$ zip -r lambda_layer.zip python > /dev/null
```
