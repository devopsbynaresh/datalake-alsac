####### FUNCTION ENVIRONMENT VARIABLES ########
variable "download_bucket_var" {
  type = string
  description = "Name of S3 bucket to download raw files from"
}

variable "upload_bucket_var" {
  type = string
  description = "Name of S3 bucket to upload compressed files to"
}

variable "athena_bucket_var" {
  type = string
  description = "Name of S3 bucket to upload Athena query logs to"
}

variable "database_var" {
  type = string
  description = "Name of Glue database for all data sources"
}

variable "fbad_table_var" {
  type = string
  description = "Name of Glue table for Facebook Ads partitions"
}

variable "gcm_table_var" {
  type = string
  description = "Name of Glue table for GCM partitions"
}

variable "gcm_sa360_cost_response_table_var" {
  type = string
  description = "Name of the Glue table for GCM standard SA360 Cost response partitions"
}

variable "gcm_sa360_transactions_table_var" {
  type = string
  description = "Name of the Glue table for GCM standard SA360 transaction partitions"
}


variable "gcm_floodlight_table_var" {
  type = string
  description = "Name of Glue table for GCM floodlight partitions"
}

variable "fbad_credentials_var" {
  type = string
  description = "Path to parameter containing Facebook Ads credentials"
}

variable "fbad_params_var" {
  type = string
  description = "Path to parameter containing Facebook Ads parameters"
}

variable "fbad_fields_var" {
  type = string
  description = "Path to parameter containing Facebook Ads fields"
}

variable "gad_credentials_var" {
  type = string
  description = "Path to parameter containing Google Ads credentials"
}

variable "gad_reports_var" {
  type = string
  description = "Path to parameter containing Google Ads report info"
}

variable "gad_query_var" {
  type = string
  description = "Google Ads query for all campaigns"
}

variable "gad_disc_query_var" {
  type = string
  description = "Google Ads query for all campaigns - Discovery"
}

variable "gad_ps_query_var" {
  type = string
  description = "Google Ads query for PaidSearch"
}

variable "gadsdisc_hist_query_var" {
  type = string
  description = "Query string for GAds Discovery without the date"
}

variable "gads_hist_query_var" {
  type = string
  description = "Query string for GAds without the date"
}

variable "gadsps_hist_query_var" {
  type = string
  description = "Query string for GAds PaidSearch without the date"
}

variable "gadsdisc_table_var" {
  type = string
  description = "Name of Glue table for GAds Discovery"
}

variable "gads_table_var" {
  type = string
  description = "Name of Glue table for GAds"
}

variable "gadsps_table_var" {
  type = string
  description = "Name of Glue table for GAds PaidSearch"
}

variable "adobe_ad_cloud_table_var" {
  type = string
  description = "Name of Glue table for Adobe Ad Cloud"
}

variable "adobe_ad_cloud_credentials_var" {
  type = string
  description = "Path to parameter containing Adobe Ad Cloud credentials"
}

############## PROCESS LAMBDA #################

variable "process_source_files" {
  type = list(string)
  description = "List of source code files for Process Lambda"
}

variable "process_package_path" {
  type = string
  description = "Path to .zip file for Process Lambda package"
}

variable "process_function_name" {
  type = string
  description = "Name of Process Lambda function"
}

variable "process_handler" {
  type = string
  description = "Name of handler in Process Lambda"
}

variable "process_timeout" {
  type = number
  description = "Max timeout for Process Lambda in seconds"
}

variable "process_memory" {
  type = number
  description = "Max memory used by Process Lambda in MB"
}

variable "process_retry_attempts" {
  type = number
  description = "Max number of retry attempts when function returns an error"
}

variable "s3rawbucket_arn" {
  type = string
  description = "ARN of s3 raw bucket"
}

######### DOWNLOAD LAMBDA ############
variable "download_source_files" {
  type = list(string)
  description = "List of source code files for Download Lambda"
}

variable "download_package_path" {
  type = string
  description = "Path to .zip file for Download Lambda package"
}

variable "download_all_function_name" {
  type = string
  description = "Name of Download Lambda function"
}

variable "download_all_handler" {
  type = string
  description = "Name of handler for Download Lambda"
}

variable "download_all_timeout" {
  type = number
  description = "Max timeout for Download Lambda in seconds"
}

variable "download_all_memory" {
  type = number
  description = "Max memory used by Download Lambda in MB"
}

variable "download_rule_arn" {
  type = string
  description = "ARN of CloudWatch Event rule to invoke Download Lambda"
}

######### HISTORICAL LAMBDA ##########

variable "historical_source_files" {
  type = list(string)
  description = "List of source code files for historical Lambda function"
}

variable "historical_package_path" {
  type = string
  description = "Location of .zip package for historical Lambda"
}

variable "historical_function_name" {
  type = string
  description = "Name of historical Lambda function"
}

variable "historical_handler_name" {
  type = string
  description = "Name of handler for historical Lambda function"
}

variable "historical_timeout" {
  type = number
  description = "Max timeout for historical Lambda"
}

variable "historical_memory" {
  type = number
  description = "Max memroy used by historical Lambda"
}

############## BACKUP PARAMETER LAMBDA ###############

variable "backup_param_rule_arn" {
  type = string
  description = "ARN of CloudWatch Event rule"
}

variable "backup_param_lambda_package" {
  type = string
  description = "Location of .zip for parameter backup Lambda function"
}

variable "backup_param_function_name" {
  type = string
  description = "Name of parameter backup Lambda function"
}

variable "param_role_arn" {
  type = string
  description = "ARN of Lambda role to be assumed by parameter backup Lambda function"
}

variable "backup_param_handler_name" {
  type = string
  description = "Name of handler for parameter backup Lambda function"
}

variable "backup_param_timeout" {
  type = number
  description = "Timeout for parameter backup Lambda function"
}

variable "backup_param_memory" {
  type = number
  description = "Max memory used for parameter backup Lambda function"
}

variable "dr_region" {
  type = string
  description = "Name of AWS DR region"
}

variable "param_lambda_policy_name" {
  type = string
  description = "Name of IAM policy for parameter backup Lambda role"
}

variable "param_lambda_role_name" {
  type = string
  description = "Name of IAM role used by parameter backup Lambda function"
}

variable "policy_name" {
  type        = string
  description = "Name of policy for Lambda role"
  default     = "lambda_policy"
}

############################

variable "date_range" {
  type        = string
  description = "Parameter containing date range for historical pull"
}

variable "gcm_folder" {
  type        = string
  description = "Folder prefix in S3 bucket for downloaded GCM data"
}

variable "gcm_subfolder" {
  type        = string
  description = "Subfolder in GCM folder"
}

variable "lambda_role_name" {
  type        = string
  description = "Name of Lambda role to be assumed by Lambda function"
}

variable "raw_bucket" {
  type        = string
  description = "ARN of S3 bucket that will execute Lambda function"
}

variable "bucket_id" {
  type        = string
  description = "ID of S3 bucket"
}

variable "role_arn" {
  type        = string
  description = "The ARN of the Lambda role to assume when running Lambdas"
}

variable "rule_arn" {
  type        = string
  description = "The ARN of the CloudWatch Event rule to trigger the Lambda function"
}

variable "runtime" {
  type        = string
  description = "Runtime to use for Lambda functions"
}

############ LAMBDA LAYERS ################

variable "awswrangler_layer_package" {
  type        = string
  description = "Location of .zip file for AWS Data Wrangler lambda layer"
}

variable "awswrangler_layer_name" {
  type        = string
  description = "Name of Lambda layers"
}

variable "common_layer_package" {
  type        = string
  description = "Location of .zip file for Common lambda layer"
}

variable "common_layer_name" {
  type        = string
  description = "Name of Lambda layers"
}

variable "facebook_layer_package" {
  type        = string
  description = "Location of .zip file for Facebook lambda layer"
}

variable "facebook_layer_name" {
  type        = string
  description = "Name of Lambda layers"
}

variable "google_layer_package" {
  type = string
  description = "Location of .zip file for Google Ads lambda layer"
}

variable "google_layer_name" {
  type = string
  description = "Name of Lambda layer"
}

######### MONITOR LAMBDA #############

variable "upload_bucket_id" {
  type        = string
  description = "Name of datalake structured S3 bucket"
}

variable "monitor_source_files" {
  type = list(string)
  description = "List of GCM code files for monitoring Lambda"
}

variable "monitor_function_name" {
  type        = string
  description = "Name of monitoring Lambda function"
}

variable "monitor_package_path" {
  type        = string
  description = "Location of .zip for monitoring Lambda"
}

variable "monitor_handler_name" {
  type        = string
  description = "Handler for monitor Lambda"
}

variable "monitor_timeout" {
  type        = number
  description = "Timeout in seconds for monitor Lambda"
}

variable "monitor_memory_size" {
  type        = number
  description = "Memory Size in MB for monitor Lambda"
}

########## GCM EXTRACT LAMBDA ############

variable "extract_source_files" {
  type = list(string)
  description = "List of GCM code files for extract Lambda"
}

variable "extract_function_name" {
  type        = string
  description = "Name of extracting Lambda function"
}

variable "extract_package_path" {
  type        = string
  description = "Location of .zip for extracting Lambda"
}

variable "extract_handler_name" {
  type        = string
  description = "Handler for extractor Lambda"
}

variable "extract_timeout" {
  type        = number
  description = "Timeout in seconds for extract Lambda"
}

variable "extract_memory_size" {
  type        = number
  description = "Memory Size in MB for extract Lambda"
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN of SNS topic for Lambda functions to publish to"
}

variable "gcm_root_parameter" {
  type        = string
  description = "Name of GCM root parameter"
}

variable "gcm_extract_criteria_env_variable" {
  type        = string
  description = "string value for object containing all criteria types"
}

######### ATHENA LAMBDA FUNCTION ###########

variable "athena_source_files" {
  type = list(string)
  description = "List of source code files for Athena Lambda function"
}

variable "athena_package_path" {
  type        = string
  description = "Location of .zip for Athena function"
}

variable "athena_function_name" {
  type        = string
  description = "Name of Athena Lambda function"
}

variable "athena_handler_name" {
  type        = string
  description = "Name of Athena Lambda handler"
}

######## Resource Tagging ########

variable "name_tag" {
  type        = string
  description = "Resource Name - unique naming convention"
  default     = ""
}

variable "application_name_tag" {
  type        = string
  description = "Application Name - MRE|Cognos|MPSC..."
  default     = ""
}

variable "owneremail_tag" {
  type        = string
  description = "App/Product Owner - email address"
  default     = ""
}

variable "environment_tag" {
  type        = string
  description = "Application Stage - Common|Prod|Dev"
  default     = ""
}

variable "role_tag" {
  type        = string
  description = "Service Radius - Web|Data|Cache"
  default     = ""
}

variable "createdate_tag" {
  type        = string
  description = "Resource Creation - date"
  default     = ""
}

variable "createby_tag" {
  type        = string
  description = "Resource Created By - userid"
  default     = ""
}

variable "lineofbusiness_tag" {
  type        = string
  description = "Financial - global|APAC|NA|EU..."
  default     = ""
}

variable "customer_tag" {
  type        = string
  description = "Financial (same as country) - WW|UK|US..."
  default     = ""
}

variable "costcenter_tag" {
  type        = string
  description = "Code provided directly from Finance"
  default     = ""
}

variable "approver_tag" {
  type        = string
  description = "Financial - email address"
  default     = ""
}

variable "lifespan_tag" {
  type        = string
  description = "Financial - date to be reviewed"
  default     = ""
}

variable "service_hours_tag" {
  type        = string
  description = "Automation - FullTime|Weekdays..."
  default     = ""
}

variable "compliance_tag" {
  type        = string
  description = "Security - PCI|PII"
  default     = ""
}

variable "project_team" {
  type        = string
  description = "Project team in charge of the resource"
  default     = ""
}

variable "s3_access_reporting_function_name" {
  type        = string
  description = "Name of S3 access reporting Lambda function"
}

variable "s3_access_reporting_lambda_package" {
  type        = string
  description = "Location of .zip for S3 access reporting Lambda"
}

variable "s3_access_reporting_handler_name" {
  type        = string
  description = "Handler for S3 access reporting Lambda"
}

variable "s3_access_reporting_timeout" {
  type        = number
  description = "Timeout in seconds for S3 access reporting Lambda"
}

variable "s3_access_reporting_memory_size" {
  type        = number
  description = "Memory Size in MB for S3 access reporting Lambda"
}

variable "s3_access_reporting_database_name" {
  type        = string
  description = "Database name for S3 access reporting"
}

variable "s3_access_reporting_bucket_name" {
  type        = string
  description = "Bucket name for S3 access reporting"
}

variable "s3_access_reporting_rule_arn" {
  type        = string
  description = "The ARN of the CloudWatch Event rule for triggering S3 Access Reporting"
}

variable "subnet_ids" {
  description = "Subnets for VPC"
  type = list(string)
}

variable "security_group_ids" {
  description = "Security group for VPC"
  type = list(string)
  
}