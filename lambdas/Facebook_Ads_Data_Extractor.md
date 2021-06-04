# Facebook Ads Data Extractor

The Facebook Ads Data Extractor is a set of AWS Lambdas for extracting data from Facebook Ads Marketing Insights into the ALSAC AWS Data Lake. It uses a configured Facebook Ads account to access the Facebook Ads Marketing APIs.

## Project Setup

Facebook Ads Data Extractor is written in Python.  It is recommended you set up a Virtual Environment for doing development. A `requirements_fbad.txt` is included with required libraries for development.

## Lambdas

All Lambdas are able to be invoked by the Lambda runtime through the handler methods.

### Download

Download is responsible for downloading report files from Facebook Ads to Lambda-local temp space and then uploading them to the raw S3 bucket.

NOTE: Facebook has an API limit, so there is a chance the Download Lambda will run into the limit if a given day has too much data. If the download Lambda fails, it will automatically retry in 1 hour.

### Download - Historical

This is similar to the Download Lambda, except it provides the ability to pull historical data (e.g. the past 6 months). The specified date range is customizable via a parameter in Systems Manager Parameter Store.

This Lambda function runs via a manual trigger and is not part of the automated portion of the data ingestion. To run the historical download Lambda, set the `historic-date-range` parameter first, and then run the Lambda function by running a Test case (any configuration will work, such as the "hello-world" template).

NOTE: Facebook has an API limit, so if you want to pull more than a few months' worth of data, you will run into the limit. The Historical download Lambda will automatically save the last successfully pulled data by updating the historic-date-range parameter in Parameter Store, specifically the "start" date. It will then automatically retry again after 6 hours, using the updated parameter.

### Process

Process is responsible for converting the raw Facebook Ads report files into structured, partitioned, compressed Parquet files.  It is triggered by a raw S3 bucket notification getting sent to an SNS topic.  It reads the Facebook Ads CSV report files and saves them as parquet files to the Lambda-local temp space.  Once the entire report is validated and converted, Process uploads them to the structured staging area, removes existing updated partitions, and moves newly created partitions into place.

### Athena Partition Loader

Athena Partition Loader runs an Athena query to load the new partitions in the Glue data catalog once Process finishes uploading the partitions in the structured S3 bucket.

## Deployment

AWS Lambdas for the Facebook Ads data ingestion are packaged in the same .zip file.  Use the provided `compress_lambda_packages.sh` or `compress_lambda_packages.bat` to package the source code files.

The Terraform scripts included will cover the initial deployment of code.  **Terraform will NOT create the required service-account parameters.**

## Deployed Info

### Parameters

In AWS, parameters are stored in the AWS Parameter Store (SSM) under the hierarchy `/data-lake/data-extractor/fbAds/`.

#### access-token

This is an opaque string that identifies a Facebook user, app, or Page. **This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a SecureString in Parameter Store.

#### account-id

This is the ID number of your Facebook Ads account, which groups your advertising activity. Your Ad Account includes your campaigns, ads, and billing.
**This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a SecureString in Parameter Store.

#### app-id

This is the unique identifier for the app that will interacting with the Facebook Graph API.
**This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a SecureString in Parameter Store.

#### app_secret

This is the app secret for the app that will be interacting with the Facebook Graph API.
**This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a SecureString in Parameter Store.

#### historic-date-range
This is a JSON string containing the date range for a historical data pull. The format should be:
```
{
    'start': 'YYYY-MM-DD',
    'stop': 'YYYY-MM-DD'
}
```
**This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a String in Parameter Store.

#### fields
This is a list of fields to include in the API response, which will become the column names of the partitions. For more information on what fields are available, see the [API documentation](https://developers.facebook.com/docs/marketing-api/insights/parameters/v7.0).
**This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a StringList in Parameter Store.

#### params
This is a JSON string of parameters to include in the API response, which will determine the level and date range of data returned. For more information on what fields are available, see the [API documentation](https://developers.facebook.com/docs/marketing-api/insights/parameters/v7.0).
**This parameter must be created manually**, as Terraform is not responsible for secrets management.  It is stored as a String in Parameter Store.

### Storage Folder structure

#### AWS
* `<RAW>:fbAds/<dataset>/<report_file>`
* `<STRUCTURED>:fbAds/<dataset>/date=<partition>/<parquet_files>`
