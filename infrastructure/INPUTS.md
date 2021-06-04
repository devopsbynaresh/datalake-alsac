# Inputs Overview

All services provisioned are imported as modules in `main.tf` in the root directory of `infrastructure`. Most of the inputs needed to configure these modules are variables that are listed in `vars.tf` in each module's folder.

**Example 1**

Say you want to change the name of the monitoring Lambda function. In `./modules/lambda/vars.tf`, the variable that determines the name of the function is:

```bash
variable "monitor_function_name" {
  type = string
  description = "Name of monitoring Lambda function"
}
```

You can change the name of the function by going to `main.tf` in the root directory and setting `monitor_function_name`:

```bash
module "lambda" {
  source = "./modules/lambda"
  
  # monitor_function_name = "dla_gcm_data_monitor"
  monitor_function_name = "my_monitor_function"
  .
  .
  .
}
```

**Example 2**

Certain variables have default values, which is why they don't appear in `main.tf` in the root folder. For example, all tags have a default value of `""`. Say you wanted to update the tag `OwnerEmail` for the Glue service. The variable that determines the tag value is in `./modules/glue/vars.tf`:

```bash
variable "owneremail_tag" {
  type = string
  description = "App/Product Owner - email address"
  default = ""
}
```

Since `owneremail_tag` isn't included in the root `main.tf` by default, you can update the value by adding a new line:

```bash
module "glue" {
  source = "./modules/glue"

  # owneremail_tag not defined here previously
  owneremail_tag = "youremail@stjude.org" # just add a new line
  .
  .
  .
}
```

**Not all variables will be used statically.** If you look at `vars.tf` in each module folder, you will notice that several of them are not listed in `main.tf` in the root directory. This is because some of the variables aren't necessarily needed for the data lake, or some of them are set to `module.<service>.<output>`. **DO NOT MODIFY any inputs that are set to a module output in main.tf.**


## Files to Modify

You will only need to modify the `main.tf` file in the root directory of `infrastructure`.

## Inputs for Provider and Terraform Backend

These inputs are in the provider and terraform blocks.

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| profile | AWS profile (~/.aws/config) to use when running Terraform | string | alsac | Yes |
| bucket | S3 bucket containing the role_creation .tfstate file | string | alsac-tfstate-development | Yes |
| key | Folder and file name within the S3 bucket to hold the .tfstate file | string | data-lake-development/infrastructure.tfstate | Yes |
| dynamodb_table | DynamoDB table to lock the .tfstate file | string | alsac-tfstate-lock-development | Yes |


## Inputs for Infrastructure Components

These inputs are passed in as variables to configure the needed AWS services.


### Lambda

#### Permissions

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| role_arn | ARN of Lambda role for Lambda functions to assume | string | arn:aws:iam::117183459779:role/sl_lambda_role | Yes |
| lambda_role_name | Name of Lambda role for Lambda functions to assume | string | sl_lambda_role | Yes |
| policy_name | Name of Lambda policy to attach to Lambda role | string | lambda_policy | Yes |

#### VPC Configuration

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| security_group_ids | Name of VPC security group to attach to Lambda functions | string | sg_id | Yes |


#### Lambda Layers

These are code libraries shared by all 4 Lambda functions.

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| awswrangler_layer_name | Name of AWS Wrangler Lambda Layer | string | awswrangler | Yes |
| awswrangler_layer_package | Location of .zip file containing AWS Wrangler Lambda Layer code | string | ../lambda-layers/awswrangler-layer-1.0.4-py3.8.zip | Yes |
| common_layer_name | Name of Common Lambda Layer | string | common | Yes |
| common_layer_package | Location of .zip file containing Common Lambda Layer code | string | ../lambda-layers/common/common-layer-1.0.0-py3.8.zip | Yes |

#### Lambda Functions

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| runtime | Language runtime for Lambda functions | string | python3.8 | Yes |
| monitor_function_name | Name of monitoring Lambda function | string | dla_gcm_data_monitor | Yes |
| monitor_lambda_package | Location of .zip file containing monitoring Lambda function code | string | ../lambdas/deployment-package-1.0.0-py3.8.zip | Yes |
| monitor_lambda_handler | Name of handler in monitoring Lambda | string | monitor.lambda_handler | Yes |
| monitor_timeout | Max amount of time for monitoring Lambda to run (seconds) | number | 300 | Yes |
| monitor_memory_size | Amount of memory available to monitoring Lambda (MB) | number | 256 | Yes |
| download_function_name | Name of downloading Lambda function | string | dla_gcm_data_download | Yes |
| download_lambda_package | Location of .zip file containing downloading Lambda function code | string | ../lambdas/deployment-package-1.0.0-py3.8.zip | Yes |
| download_lambda_handler | Name of handler in downloading Lambda | string | download.lambda_handler | Yes |
| download_timeout | Max amount of time for downloading Lambda to run (seconds) | number | 900 | Yes |
| download_memory_size | Amount of memory available to downloading Lambda (MB) | number | 512 | Yes |
| process_function_name | Name of processing Lambda function | string | dla_gcm_data_process | Yes |
| process_lambda_package | Location of .zip file containing processing Lambda function code | string | ../lambdas/deployment-package-1.0.0-py3.8.zip | Yes |
| process_lambda_handler | Name of handler in processing Lambda | string | process.lambda_handler | Yes |
| process_timeout | Max amount of time for processing Lambda to run (seconds) | number | 900 | Yes |
| process_memory_size | Amount of memory available to processing Lambda (MB) | number | 512 | Yes |
| extract_function_name | Name of extractor Lambda function | string | dla_gcm_data_extract | Yes |
| extract_lambda_package | Location of .zip file containing extractor Lambda function code | string | ../lambdas/deployment-package-1.0.0-py3.8.zip | Yes |
| extract_lambda_handler | Name of handler in extractor Lambda | string | extract.lambda_handler | Yes |
| extract_timeout | Max amount of time for extractor Lambda to run (seconds) | number | 900 | Yes |
| extract_memory_size | Amount of memory available to extractor Lambda (MB) | number | 512 | Yes |


### Glue

#### Permissions

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| role_name | Name of role for Glue crawlers to assume | string | sl_glue_role | Yes |
| policy_name | Name of policy to attach to role | string | glue_policy | Yes |

#### Glue Crawlers and Databases

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| raw_crawler | Name of Glue crawler to crawl raw S3 bucket | string | raw_crawler | Yes |
| raw_catalog_database | Name of Glue database for raw Glue crawler | string | raw_database | Yes |
| curated_crawler | Name of Glue crawler to crawl curated S3 bucket | string | curated_crawler | Yes |
| curated_catalog_database | Name of Glue database for curated Glue crawler | string | curated_database | Yes |

### CloudWatch Events

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| name | Name of CloudWatch Event rule | string | monitor-lambda-trigger | Yes |
| description | Description of the event rule | string | Hourly cron job to kick off Monitoring Lambda function | No |
| schedule | Schedule expression of the event rule (cron() or rate()) | string | rate(1 hour) | Yes |
| target_id | Unique target assignment ID of event rule | string | SendToMonitorLambda | No |

### CloudWatch Metric Alarms

The scripts create four metric alarms, one for each Lambda function. They all have the same configuration except for `alarm_name`.

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| alarm_name | Name of metric alarm | string | datalake-monitoring-lambda-error | Yes |
| alarm_description | Description of metric alarm | string | Monitoring Lambda encountered an error | No |
| comparison_operator | Arithmetic operation to use when comparing statistic and threshold (GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold) | string | GreaterThanOrEqualToThreshold | Yes |
| evaluation_periods | Number of periods over which data is compared to threshold | number | 1 | Yes |
| threshold | Value to compare statistic against | number | 1 | Yes |
| unit | Unit for metric alarm | string | Count | Yes |
| metric_name | Name of metric | string | Errors | Yes |
| namespace | Namespace of metric | string | AWS/Lambda | Yes |
| period | Period where statistic is applied (seconds) | number | 60 | Yes |
| statistic | Statistic to apply to metric (SampleCount, Average, Sum, Minimum, Maximum) | string | 60 | Yes |


### SNS

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| lambda_topic_name | Name of SNS topic to trigger processing Lambda function | string | lambda_sns_topic | Yes |
| event_topic_name | Name of SNS topic to send notifications when Lambda encounters errors | string | event_sns_topic | Yes |

### Tags

Each module includes standard tags based on the document from CloudReach.

*NOTE:* The tag values defined by `project_team` and `environment_tag` are currently being used for implementing ABAC within the scripts.

| Input | Description | Type | Default | Required? |
| ----- | ----------- | ---- | ------- | --------- |
| name_tag | Unique resource name | string | | No |
| application_name_tag | Application name | string | | No |
| owneremail_tag | App/Product owner | string | | No |
| environment_tag | Application stage/environment | string | dev | Yes |
| role_tag | Service radius - Web/Data/Cache | string | | No |
| createdate_tag | Resource creation date | string | timestamp() | No |
| createby_tag | Resource created by - userid | string | | No |
| lineofbusiness_tag | Financial line of business (global/APAC/NA/EU/etc) | string | NA | No |
| customer_tag | Financial (same as country) | string | US | No |
| costcenter_tag | Code provided directly from Finance | string | 5760 4560 5418 | No |
| approver_tag | Financial approver (e-mail address) | string | | No |
| lifespan_tag | Date to be reviewed | string | | No |
| service-hours_tag | Automation (fulltime/weekdays/etc) | string | | No |
| compliance_tag | Security (PCI/PII) | string | | No |
| project_team | Project team in charge of resource | string | datalake | Yes |
