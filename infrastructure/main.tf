#### PROVIDER INFO ####
provider "aws" {
  region  = var.region
  version = "~> 2.56"

  # Change profile to "saml" if you are using saml2aws and have the default profile ("saml") configured
  #profile = "alsac"
  profile = "saml"
}

#### TERRAFORM BACKEND ####
# This sets up the backend for Terraform to ensure the state file is centralized and doesn't get corrupted
# if multiple developers are deploying these Terraform scripts.
terraform {
  backend "s3" {
    # Change profile to "saml" if you are using saml2aws and have the default profile ("saml") configured
    #profile = "alsac"
    profile = "saml"

  }
}

data "aws_subnet" "subnet1" {
    filter {
      name = "tag:Name"
      values = ["sn-${var.env}-priv-1a"]
    }
}

data "aws_subnet" "subnet2" {
    filter {
      name = "tag:Name"
      values = ["sn-${var.env}-priv-1b"]
    }
}

data "aws_vpc" "vpc" {
    filter {
      name = "tag:Name"
      values = ["vpc-use1-${var.env}"]
    }
}
resource "aws_security_group" "glue_datadb-connection" {
  name = "glue_datadb-connection_${var.env}"
  description = "Security group for glue"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.154/32"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    self             = true
  }
  egress {
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.154/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    self             = true
  }
  
  tags = {
    Name = "glue_datadb-connection_${var.env}"
  }
}
resource "aws_security_group" "sg_lambda" {
  name = "sg_lambda"
  description = "Security group for Lambdas"
  vpc_id = data.aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_lambda_${var.env}"
  }
}

#### GLUE CATALOG ####
# This creates Glue catalog databases and crawlers to extract the data from the buckets into tables,
# so that Athena can query the tables.
module "glue" {
  source = "./modules/glue"

  # Database for all data sources
  data_catalog_database_name = "performance_marketing_digital_media"

  # Facebook Ads table
  fbad_table_name     = "fb_ads_platform_performance_daily"
  fbad_table_location = "s3://alsac-${var.env}-dla-structured/fbAds/platform_performance_daily/"

  # GCM standard table
  gcm_table_name     = "gcm_platform_performance_daily"
  gcm_table_location = "s3://alsac-${var.env}-dla-structured/gcm/platform_performance_daily/"


  # GCM standard SA360 CostResponse Daily table
  gcm_sa360_cost_response_table_name     = "gcm_sa360_cost_response_daily"
  gcm_sa360_cost_response_table_location = "s3://alsac-${var.env}-dla-structured/gcm/sa360_cost_response_daily/"

  # GCM standard SA360 Transactions Daily table
  gcm_sa360_transactions_table_name     = "gcm_sa360_transactions_daily"
  gcm_sa360_transactions_table_location = "s3://alsac-${var.env}-dla-structured/gcm/sa360_transactions_daily/"


  # Google Ads Display table
  gads_table_name     = "gads_platform_display_daily"
  gads_table_location = "s3://alsac-${var.env}-dla-structured/google_ads/GAds/"

  # Google Ads Discovery table
  gadsdisc_table_name     = "gads_platform_discovery_daily"
  gadsdisc_table_location = "s3://alsac-${var.env}-dla-structured/google_ads/GAdsDISC/"

  # Google Ads PaidSearch table
  gadsps_table_name     = "gads_platform_paidsearch_daily"
  gadsps_table_location = "s3://alsac-${var.env}-dla-structured/google_ads/GAdsPS/"

  # GCM Floodlight table
  gcm_floodlight_table_name     = "gcm_platform_floodlight_daily"
  gcm_floodlight_table_location = "s3://alsac-${var.env}-dla-structured/gcm/gcm_daily_floodlight/"

  # Adobe AdCloud table
  aac_table_name                = "aac_platform_performance_daily"
  adobe_ad_cloud_table_location = "s3://alsac-${var.env}-dla-structured/aac/platform_performance_daily/"

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}


#### LAMBDA FUNCTIONS ####
# This deploys the Lambda functions to monitor, download, and process data from an external source.
module "lambda" {
  source = "./modules/lambda"

  # Role for Lambda functions to assume. This role was created from the role_creation Terraform scripts.
  role_arn         = "arn:aws:iam::${var.account_id}:role/sl_lambda_role"
  lambda_role_name = "sl_lambda_role"
  runtime          = "python3.8"

  #VPC Configuration

  subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]
  security_group_ids = [aws_security_group.sg_lambda.id]

  # Lambda layers
  awswrangler_layer_package = "../lambda-layers/awswrangler-layer-1.10.0-py3.8.zip"
  awswrangler_layer_name    = "awswrangler"
  common_layer_package      = "../lambda-layers/common/common-layer-1.0.0-py3.8.zip"
  common_layer_name         = "common"
  #facebook_layer_package    = "../lambda-layers/facebook-layer.zip"
  facebook_layer_package = "../lambda-layers/facebook-layer_v10.zip"
  facebook_layer_name    = "facebook"
  google_layer_package   = "../lambda-layers/google/google-layer.zip"
  google_layer_name      = "google"

  # ENVIRONMENT VARIABLES #
  download_bucket_var = "alsac-${var.env}-dla-raw"                      # Name of raw S3 bucket
  upload_bucket_var   = "alsac-${var.env}-dla-structured"               # Name of structured S3 bucket
  athena_bucket_var   = "alsac-${var.env}-dla-aws-athena-query-results" # Name of Athena S3 bucket

  database_var                      = "performance_marketing_digital_media"     # Name of Glue catalog database
  fbad_table_var                    = module.glue.fbad_table                    # Name of Glue table for Facebook Ads
  gcm_table_var                     = module.glue.gcm_table                     # Name of Glue table for GCM standard
  gcm_sa360_cost_response_table_var = module.glue.gcm_sa360_cost_response_table # Name of the Glue table for GCM SA360 Cost Response table
  gcm_sa360_transactions_table_var  = module.glue.gcm_sa360_transactions_table  # Name of the Glue table for GCM SA360 transactions table
  gcm_floodlight_table_var          = module.glue.gcm_floodlight_table          # Name of Glue table for GCM floodlight
  gads_table_var                    = module.glue.gads_table                    # Name of Glue table for Google Ads Display
  gadsdisc_table_var                = module.glue.gadsdisc_table                # Name of Glue table for Google Ads Discovery
  gadsps_table_var                  = module.glue.gadsps_table                  # Name of Glue table for Google Ads PaidSearch
  adobe_ad_cloud_table_var          = module.glue.adobe_ad_cloud_table          # Name of Glue table for Adobe AdCloud

  # Name of SSM parameters used for data source ingestion
  adobe_ad_cloud_credentials_var = "/data-lake/data-extractor/adobe-ad-cloud/service-account" # Adobe AdCloud credentials
  fbad_credentials_var           = "/data-lake/data-extractor/fbAds/service-account"          # Facebook Ads credentials
  fbad_params_var                = "/data-lake/data-extractor/fbAds/params"                   # Facebook Ads parameters
  fbad_fields_var                = "/data-lake/data-extractor/fbAds/fields"                   # Facebook Ads fields
  gad_credentials_var            = "/data-lake/data-extractor/google-ads/service-account"     # Google Ads credentials
  gad_reports_var                = "/data-lake/data-extractor/google-ads/report-info"         # Google Ads report-info
  date_range                     = "/data-lake/data-extractor/historic-date-ranges"           # Historical date range

  # Queries for Google Ads
  gad_query_var           = "SELECT campaign.name, ad_group.name, segments.device, metrics.cost_micros FROM ad_group WHERE segments.date DURING YESTERDAY"
  gad_disc_query_var      = "SELECT campaign.name, ad_group.name, segments.device, metrics.impressions FROM ad_group WHERE segments.date DURING YESTERDAY"
  gad_ps_query_var        = "SELECT campaign.name, ad_group.name, segments.device, metrics.cost_micros, metrics.impressions FROM ad_group WHERE segments.date DURING YESTERDAY"
  gadsdisc_hist_query_var = "SELECT campaign.name, ad_group.name, segments.device, metrics.impressions FROM ad_group WHERE segments.date ="
  gads_hist_query_var     = "SELECT campaign.name, ad_group.name, segments.device, metrics.cost_micros FROM ad_group WHERE segments.date ="
  gadsps_hist_query_var   = "SELECT campaign.name, ad_group.name, segments.device, metrics.cost_micros, metrics.impressions FROM ad_group WHERE segments.date ="

  # Process Lambda
  process_source_files = [
    "../lambdas/src/process.py",
    "../lambdas/src/gcm/process.py",
    "../lambdas/src/google_ads/process.py"
  ]
  process_package_path   = "process_lambda.zip"
  process_function_name  = "dla_data_process_all"
  process_handler        = "process.handler"
  process_timeout        = 900
  process_memory         = 512
  process_retry_attempts = 0
  s3rawbucket_arn        = "arn:aws:s3:::alsac-${var.env}-dla-raw"

  # Download Lambda
  download_source_files = [
    "../lambdas/src/download.py",
    "../lambdas/src/facebook_ads/download.py",
    "../lambdas/src/google_ads/download.py",
    "../lambdas/src/gcm/download.py",
    "../lambdas/src/gcm/config.py",
    "../lambdas/src/gcm/process.py",
    "../lambdas/src/adobe_ad_cloud/download.py"
  ]
  download_package_path      = "download_lambda.zip"
  download_all_function_name = "dla_data_download_all"
  download_all_handler       = "download.handler"
  download_all_timeout       = 900
  download_all_memory        = 256
  download_rule_arn          = module.event-rule.download_event_rule_arn

  # Historical Download Lambda
  historical_source_files = [
    "../lambdas/src/historical_download.py",
    "../lambdas/src/facebook_ads/historical_download.py",
    "../lambdas/src/google_ads/historical_download.py",
    "../lambdas/src/adobe_ad_cloud/historical_download.py"
  ]
  historical_package_path  = "historical_lambda.zip"
  historical_function_name = "dla_data_historical_download_all"
  historical_handler_name  = "historical_download.handler"
  historical_timeout       = 900
  historical_memory        = 256

  # GCM parameters
  raw_bucket                   = "arn:aws:s3:::alsac-${var.env}-dla-raw"
  bucket_id                    = "alsac-${var.env}-dla-raw"
  upload_bucket_id             = "alsac-${var.env}-dla-structured"
  gcm_subfolder                = "platform_performance_daily"
  gcm_folder                   = "gcm/"
  gcm_root_parameter           = "/data-lake/data-extractor/gcm/"
  sns_topic_arn                = module.sns.lambda_topic_arn
  rule_arn                     = module.event-rule.event_rule_arn
  s3_access_reporting_rule_arn = module.event-rule.s3_access_reporting_rule_arn

  # Monitoring Lambda function - GCM
  monitor_source_files = [
    "../lambdas/src/gcm/monitor.py",
    "../lambdas/src/gcm/config.py",
    "../lambdas/src/gcm/download.py"
  ]
  monitor_function_name = "dla_gcm_data_monitor"
  monitor_package_path  = "gcm_monitor_lambda.zip"
  monitor_handler_name  = "monitor.lambda_handler"
  monitor_timeout       = 300
  monitor_memory_size   = 256

  # Extractor Lambda function - GCM
  extract_source_files = [
    "../lambdas/src/gcm/extract.py",
    "../lambdas/src/gcm/monitor.py",
    "../lambdas/src/gcm/download.py",
    "../lambdas/src/gcm/process.py",
    "../lambdas/src/gcm/config.py"
  ]
  extract_function_name             = "dla_gcm_data_extract"
  extract_package_path              = "gcm_extract_lambda.zip"
  extract_handler_name              = "extract.lambda_handler"
  extract_timeout                   = 900
  extract_memory_size               = 512
  gcm_extract_criteria_env_variable = "{'CROSS_DIMENSION_REACH':'crossDimensionReachCriteria', 'PATH_TO_CONVERSION': 'pathToConversionCriteria', 'REACH' :'reachCriteria', 'FLOODLIGHT': 'floodlightCriteria', 'STANDARD': 'criteria' }"

  # Athena Lambda function
  athena_source_files = [
    "../lambdas/src/athena.py"
  ]
  athena_function_name = "dla_athena_load_partitions"
  athena_package_path  = "athena-deployment-package.zip"
  athena_handler_name  = "athena.handler"

  # S3 Access Reporting Lambda function
  s3_access_reporting_function_name  = "dla_s3_access_reporting"
  s3_access_reporting_lambda_package = "s3_access_reporting.zip"
  s3_access_reporting_handler_name   = "s3_access_reporting.handler"
  s3_access_reporting_timeout        = 300
  s3_access_reporting_memory_size    = 256
  s3_access_reporting_database_name  = "s3_access_reporting"
  s3_access_reporting_bucket_name    = "alsac-${var.env}-dla-log"

  # Parameter Backup Lambda function
  param_lambda_role_name      = "backup_params_lambda_role"
  param_role_arn              = "arn:aws:iam::${var.account_id}:role/backup_params_lambda_role"
  param_lambda_policy_name    = "backup_params_lambda_policy"
  dr_region                   = "us-west-2"
  backup_param_rule_arn       = module.event-rule.backup_param_rule_arn
  backup_param_lambda_package = "backup_params.zip"
  backup_param_function_name  = "dla_backup_parameters"
  backup_param_handler_name   = "backup_nonsecure_params.lambda_handler"
  backup_param_timeout        = 120
  backup_param_memory         = 128

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}


#### SNS TOPICS ####
# This creates an SNS topic for the monitoring Lambda function to trigger the downloading Lambda function
# and another SNS topic to notify of any Lambda function errors.
module "sns" {
  source = "./modules/sns"

  # Name of SNS topics
  lambda_topic_name              = "lambda_sns_topic"
  data_lake_team_topic_name      = "data_lake_team_sns_topic"
  infrastructure_team_topic_name = "infrastructure_team_sns_topic"

  # Lambda target if Monitoring Lambda publishes to SNS
  lambda_endpoint_arn = module.lambda.download_all_function_arn

  # Assume role to allow writes to CloudWatch Logs if there are errors delivering messages
  role_arn = "arn:aws:iam::${var.account_id}:role/access_logs_role"

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}


#### CLOUDWATCH SCHEDULED EVENT RULE ####
# This creates a recurring schedule to trigger the monitoring Lambda to look for any new data in the 
# external data source.
module "event-rule" {
  source = "./modules/event-rule"

  # Event rule for GCM monitor Lambda function
  name               = "monitor-lambda-trigger"
  description        = "Hourly cron job to kick off Monitoring Lambda function"
  schedule           = "rate(1 hour)"
  target_id          = "SendToMonitorLambda"
  monitor_lambda_arn = module.lambda.monitor_function_arn

  # Event rule for S3 access reporting Lambda function
  s3_access_reporting_name        = "s3-access-reporting-trigger"
  s3_access_reporting_description = "CRON to run the S3 Access Reporting lambda every Tuesday at midnight UTC"
  s3_access_reporting_schedule    = "cron(0 0 ? * 3 *)"
  s3_access_reporting_target_id   = "TriggerS3AccessReporting"
  s3_access_reporting_lambda_arn  = module.lambda.s3_access_reporting_function_arn

  # Event rule for parameter backup Lambda function
  backup_param_name        = "backup-param-trigger"
  backup_param_description = "Daily cron job to kick off Parameter Backup Lambda function"
  backup_param_schedule    = "cron(0 0 * * ? *)"
  backup_param_target_id   = "TriggerBackupParameter"
  backup_param_lambda_arn  = module.lambda.backup_param_function_arn

  # Event rule for Download - ALL Lambda function
  download_lambda_name        = module.lambda.download_all_function_name
  download_lambda_description = "Daily cron job to kick off Download Lambda function"
  download_lambda_schedule    = "cron(0 7 * * ? *)"
  download_target_id          = "TriggerDownloadAllLambda"
  download_lambda_arn         = module.lambda.download_all_function_arn
}


#### CLOUDWATCH ALARM - MONITORING LAMBDA ####
# This creates a CloudWatch metric alarm for any errors from the monitoring Lambda function.
module "monitor-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-monitoring-lambda-error"
  alarm_description   = "Monitoring Lambda encountered an error"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    FunctionName = module.lambda.monitor_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - MONITORING LAMBDA DURATION ####
# This creates a CloudWatch metric alarm for an abnormallly long duration of the monitoring Lambda function.
module "monitor-duration-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-monitoring-lambda-duration"
  alarm_description   = "Monitoring Lambda has a long duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 10000

  namespace   = "AWS/Lambda"
  metric_name = "Duration"
  period      = 3600
  statistic   = "Maximum"
  unit        = "Milliseconds"

  dimensions = {
    FunctionName = module.lambda.monitor_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - LOAD PARTITIONS LAMBDA ####
# This creates a CloudWatch metric alarm for any errors from the Athena load partitions Lambda function.
module "load-partitions-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-load-partitions-lambda-error"
  alarm_description   = "Load partitions Lambda encountered an error"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    FunctionName = module.lambda.partitions_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - LOAD PARTITIONS LAMBDA DURATION ####
# This creates a CloudWatch metric alarm for an abnormallly long duration of the Athena load partitions Lambda function.
module "load-partitions-duration-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-load-partitions-duration-lambda-error"
  alarm_description   = "Load partitions Lambda has a long duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 2000

  namespace   = "AWS/Lambda"
  metric_name = "Duration"
  period      = 3600
  statistic   = "Maximum"
  unit        = "Milliseconds"

  dimensions = {
    FunctionName = module.lambda.partitions_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - DOWNLOADING LAMBDA ####
# This creates a CloudWatch metric alarm for any errors from the downloading Lambda function.
module "download-all-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-download-all-lambda-error"
  alarm_description   = "Downloading Lambda encountered an error"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    FunctionName = module.lambda.download_all_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - DOWNLOADING LAMBDA DURATION ####
# This creates a CloudWatch metric alarm for an abnormallly long duration of the downloading Lambda function.
module "download-all-duration-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-download-all-lambda-duration"
  alarm_description   = "Downloading Lambda has a long duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 10000

  namespace   = "AWS/Lambda"
  metric_name = "Duration"
  period      = 3600
  statistic   = "Maximum"
  unit        = "Milliseconds"

  dimensions = {
    FunctionName = module.lambda.download_all_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - PROCESSING LAMBDA ####
# This creates a CloudWatch metric alarm for any errors from the processing Lambda function.
module "process-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-processing-lambda-error"
  alarm_description   = "Processing Lambda encountered an error"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/Lambda"
  metric_name = "Errors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    FunctionName = module.lambda.process_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - PROCESSING LAMBDA DURATION ####
# This creates a CloudWatch metric alarm for an abnormallly long duration of the processing Lambda function.
module "processing-duration-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-processing-lambda-duration"
  alarm_description   = "Processing Lambda has a long duration"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 8000

  namespace   = "AWS/Lambda"
  metric_name = "Duration"
  period      = 3600
  statistic   = "Maximum"
  unit        = "Milliseconds"

  dimensions = {
    FunctionName = module.lambda.process_function_name
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - DATA LAKE TEAM SNS TOPIC ERRORS ####
# This creates a CloudWatch metric alarm for any failed notifications with the SNS topic for Lambda.
module "datalake-sns-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "datalake-sns-topic-error"
  alarm_description   = "The Lambda SNS topic failed to deliver a message"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/SNS"
  metric_name = "NumberOfNotificationsFailed"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - Billing Estimated Charges ####
# This creates a CloudWatch metric alarm for a higher-than-usual estimated account spend.
module "billing-sns-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "high-estimated-charges"
  alarm_description   = "Account spend is estimated to be higher than usual."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 150

  namespace   = "AWS/Billing"
  metric_name = "EstimatedCharges"
  period      = 3600
  statistic   = "Maximum"
  unit        = "None"

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.infrastructure_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - DynamoDB System Errors ####
# This creates a CloudWatch metric alarm for DynamoDB system errors.
module "dynamodb-system-error-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "dynamodb-system-error-alarm"
  alarm_description   = "CloudWatch metric alarm for DynamoDB system errors."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/DynamoDB"
  metric_name = "SystemErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.infrastructure_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - DynamoDB Client Errors ####
# This creates a CloudWatch metric alarm for DynamoDB client errors.
module "dynamodb-client-error-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "dynamodb-client-error-alarm"
  alarm_description   = "CloudWatch metric alarm for DynamoDB client errors."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/DynamoDB"
  metric_name = "UserErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.infrastructure_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - CloudWatch Event Failed Invocations ####
# This creates a CloudWatch metric alarm for CloudWatch Event failed invocations.
module "cloudwatch-event-failure-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "cloudwatch-event-failure-alarm"
  alarm_description   = "CloudWatch metric alarm for CloudWatch Event failed invocations"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/Events"
  metric_name = "FailedInvocations"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - Structured S3 Client Errors ####
# This creates a CloudWatch metric alarm for any client errors corresponding to the structured bucket.
module "structured-client-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "structured-client-alarm"
  alarm_description   = "Metric alarm for any client errors corresponding to the structured bucket."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/S3"
  metric_name = "4xxErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    BucketName = "alsac-${var.env}-dla-structured"
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - Structured S3 System Errors ####
# This creates a CloudWatch metric alarm for any system errors corresponding to the structured bucket.
module "structured-system-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "structured-system-alarm"
  alarm_description   = "Metric alarm for any system errors corresponding to the structured bucket."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/S3"
  metric_name = "5xxErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    BucketName = "alsac-${var.env}-dla-structured"
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - Raw S3 Client Errors ####
# This creates a CloudWatch metric alarm for any client errors corresponding to the raw bucket.
module "raw-client-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "raw-client-alarm"
  alarm_description   = "Metric alarm for any client errors corresponding to the raw bucket."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/S3"
  metric_name = "4xxErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    BucketName = "alsac-${var.env}-dla-raw"
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - Raw S3 System Errors ####
# This creates a CloudWatch metric alarm for any system errors corresponding to the raw bucket.
module "raw-system-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "raw-system-alarm"
  alarm_description   = "Metric alarm for any system errors corresponding to the raw bucket."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/S3"
  metric_name = "5xxErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    BucketName = "alsac-${var.env}-dla-raw"
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - Logging S3 Client Errors ####
# This creates a CloudWatch metric alarm for any client errors corresponding to the logging bucket.
module "logging-client-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "logging-client-alarm"
  alarm_description   = "Metric alarm for any client errors corresponding to the logging bucket."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/S3"
  metric_name = "4xxErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    BucketName = "alsac-${var.env}-dla-log"
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CLOUDWATCH ALARM - Logging S3 System Errors ####
# This creates a CloudWatch metric alarm for any system errors corresponding to the logging bucket.
module "logging-system-alarm" {
  source = "./modules/metric-alarm"

  alarm_name          = "logging-system-alarm"
  alarm_description   = "Metric alarm for any system errors corresponding to the logging bucket."
  comparison_operator = "GreaterThanOrEqualToThreshold"

  # Threshold can be modified
  evaluation_periods = 1
  threshold          = 1

  namespace   = "AWS/S3"
  metric_name = "5xxErrors"
  period      = 3600
  statistic   = "Sum"
  unit        = "Count"

  dimensions = {
    BucketName = "alsac-${var.env}-dla-log"
  }

  # Publishes to SNS topic if alarm is active
  alarm_actions = [module.sns.data_lake_team_topic_arn]

  # Tags
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = "2020-05-06"
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}

#### CloudTrail Trail - S3 Object Event Logs ####
# This creates a CloudTrail trail for logging S3 Object Events to use in reporting.
module "s3-cloudtrail" {
  source             = "./modules/cloudtrail"
  name               = "s3-object-event-log-trail"
  s3_bucket_name     = "alsac-${var.env}-dla-log"
  project_team       = "datalake"
  environment_tag    = var.env
  createdate_tag     = ""
  lineofbusiness_tag = "NA"
  customer_tag       = "US"
  costcenter_tag     = "5760 4560 5418"
}


#### Data Lake Monitoring Dashboard ####
# This creates a CloudWatch dashboard for monitoring the data lake.
module "monitoring" {
  source         = "./modules/monitoring"
  dashboard_name = "datalake-monitoring-dashboard"
}
