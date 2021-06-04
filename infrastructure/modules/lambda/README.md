# Lambda Functions

> This only deploys the Lambda functions. To learn more about the code within the Lambda functions, see the [Lambdas README](../../../lambdas/README.md).

# Data Pipeline

Deploys five Lambda functions in Python 3.8: GCM Monitor, Download, Process, GCM Extract, and Athena Partitions Loader. The code is in stored [here](../../../lambdas/src/).

- **GCM Monitor:** Checks for new data from GCM. If new data is found, it will publish to an SNS topic.
- **Download:** This is triggered by either the GCM SNS topic or a daily CloudWatch Event rule. The Download function will call on helper functions for each data source to download raw CSV files to the raw S3 bucket.
- **Process:** Once the raw files are uploaded to the raw S3 bucket, the Download function will invoke the Process function. The Process function will convert the raw data into curated data as a Parquet file, and then upload the Parquet partitions to the structured S3 bucket.
- **GCM Extract:** The Extract function sets up the environment for the GCM Monitor and Download helper functions. It sets up the daily load, full history pull, data type validation, etc.
- **Athena Partitions Loader:** After the Process function uploads the Parquet files to S3, it invokes the Athena function to run an `MSCK REPAIR` Athena query. This loads the new partition metadata into the Glue tables for all data sources.
- **Historical Download:** To grab historical data for a given data source, you can pass in the data source abbreviation and the date range.

The Monitor, Download, Process, and Athena Partitions Loader functions are in an automated process. The Extract function and Historical Download function are only to be manually run by someone in the developer role (default: sl_data_team_role).

An IAM policy was also created to provide the Lambda functions limited access to SSM Parameter Store, S3 buckets, CloudWatch Events, CloudWatch Logs, and SNS.

Lambda permissions were also configured to allow CloudWatch Events and SNS to be Lambda triggers.

# Reporting and Backup

Deploys three Lambda functions in Python 3.8: [S3 Access Reporting](../../../lambdas/s3_access_reporting), [AWS Account Access Reporting](../../../lambdas/aws_access_reporting), and [Parameter Backup](../../../lambdas/backup_parameters).

- **S3 Access Reporting**: The S3 access reporting function takes an S3 bucket name as input and, with the right permissions in place, uses Athena to process CloudTrail data and create S3 access reports for new and historical log data.
- **AWS Account Access Reporting**: The AWS access reporting function takes an S3 bucket name as input and, with the right permissions in place, uses Athena to process CloudTrail data and create AWS access reports for new and historical log data.
- **Parameter Backup**: The Parameter Backup function queries any non-SecureString parameters in Parameter Store and uploads them to Parameter Store to a different region in the same account. This can be changed to a different account (such as the DR account) in the future, but an IAM role must be created in the new account and allow the Lambda function to assume it.
  - An IAM policy was created to provide this Lambda function limited access to SSM Parameter Store
  - Lambda permissions were also configured to allow a CloudWatch Event rule to trigger the function daily

### Dependencies

All of the Lambda functions share code libraries and environment variables.

- The code libraries are packaged as Lambda Layers that are attached to each function:
  - **google:** includes the GCM and Google Ads API libraries; used by the Download and Historical Download Lambdas
  - **facebook:** include the Facebook Ads API libraries; used by the Download and Historical Download Lambdas
  - **AWS Wrangler:** includes the `oauth2client` and `google-api-python-client`; used by the Process Lambda
  - **Common:** includes the `pandas` and `pyarrow`; used by the Process Lambda
