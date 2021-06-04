######################## IAM #########################

# Policy for lambda role used for backing up parameters
resource "aws_iam_policy" "lambda_backup_params_policy" {
  name = var.param_lambda_policy_name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowedSSMActionsForBackup",
      "Action": [
        "ssm:*Parameter*",
        "ssm:AddTagsToResource"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
     {
      "Sid": "VPCExecutionRolePermissions",
      "Effect": "Allow",
      "Action": [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach policy to lambda role
resource "aws_iam_role_policy_attachment" "attach_param_policy" {
  role       = var.param_lambda_role_name
  policy_arn = aws_iam_policy.lambda_backup_params_policy.arn
}

# Policy for lambda role used for data ingestion
resource "aws_iam_policy" "lambda_policy" {
  name   = var.policy_name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowedLambdaActions",
      "Action": "lambda:Invoke*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "AllowedAthenaAndGlueActions",
      "Action": [
        "athena:*Query*",
        "glue:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "AllowedCloudWatchAndSNSActions",
      "Action": [
        "cloudwatch:*",
        "logs:*",
        "sns:Publish*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "AllowedSSMActions",
      "Effect": "Allow",
      "Action": [
        "ssm:*Parameter",
        "ssm:AddTagsToResource"
      ],
      "Resource": "*",
      "Condition": {
        "StringEqualsIfExists": {
          "ssm:ResourceTag/ProjectTeam": "datalake",
          "ssm:ResourceTag/Environment": "${var.environment_tag}"
        }
      }
    },
    {
      "Sid": "AllowedS3Actions",
      "Effect": "Allow",
      "Action": [
        "s3:List*",
        "s3:Get*",
        "s3:*Object"
      ],
      "Resource": "*",
      "Condition": {
        "StringEqualsIfExists": {
          "s3:ResourceTag/ProjectTeam": "datalake",
          "s3:ResourceTag/Environment": "${var.environment_tag}"
        }
      }
    },
    {
      "Sid": "VPCExecutionRolePermissions",
      "Effect": "Allow",
      "Action": [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach policy to lambda role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = var.lambda_role_name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

######################## LAMBDA LAYERS ############################

# Deploy awswrangler Lambda layer to be used by Lambda functions
resource "aws_lambda_layer_version" "awswrangler_layer" {
  filename   = var.awswrangler_layer_package
  layer_name = var.awswrangler_layer_name
}

# Deploy common Lambda layer to be used by Lambda functions
resource "aws_lambda_layer_version" "common_layer" {
  filename   = var.common_layer_package
  layer_name = var.common_layer_name
}

# Deploy facebook Lambda layer to be used by Lambda functions
resource "aws_lambda_layer_version" "facebook_layer" {
  filename   = var.facebook_layer_package
  layer_name = var.facebook_layer_name
}

# Deploy google layer: contains both GCM and Google Ads APIs
resource "aws_lambda_layer_version" "google_layer" {
  filename = var.google_layer_package
  layer_name = var.google_layer_name
}

####################### LOCALS ###########################

locals {
  # Local source code files for process Lambda
  process_source_files = var.process_source_files

  # Local source code files for download Lambda
  download_source_files = var.download_source_files

  # Local source code files for historical download Lambda
  historical_source_files = var.historical_source_files

  # Local source code files for GCM monitor Lambda
  gcm_monitor_source_files = var.monitor_source_files

  # Local source code files for GCM extract Lambda
  gcm_extract_source_files = var.extract_source_files

  # Local source code files for Athena Lambda
  athena_source_files = var.athena_source_files
}

######################## PROCESS LAMBDA ###########################
# This Lambda function converts any new CSV files that are uploaded to the raw bucket into Parquet files
# to store in the structured bucket.

# Create template_file containing source code files
data "template_file" "process_file" {
  count = "${length(local.process_source_files)}"
  template = "${file(element(local.process_source_files, count.index))}"
}

# Automatically create zip package
data "archive_file" "process_zip" {
  type = "zip"
  output_path = var.process_package_path

  source {
    filename = "${basename(local.process_source_files[0])}"
    content = "${data.template_file.process_file.0.rendered}"
  }
  source {
    filename = "gcm/${basename(local.process_source_files[1])}"
    content = "${data.template_file.process_file.1.rendered}"
  }
  source {
    filename = "google_ads/${basename(local.process_source_files[2])}"
    content = "${data.template_file.process_file.2.rendered}"
  }
}

# Deploy Process Lambda function
resource "aws_lambda_function" "process_all" {
  filename = var.process_package_path
  source_code_hash = data.archive_file.process_zip.output_base64sha256
  function_name = var.process_function_name
  runtime = var.runtime
  role = var.role_arn
  handler = var.process_handler
  timeout = var.process_timeout
  memory_size = var.process_memory
  layers = [aws_lambda_layer_version.awswrangler_layer.arn, aws_lambda_layer_version.common_layer.arn]

  #VPC configuration for process all lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids

  }
  environment {
    variables = {
      UPLOAD_BUCKET = var.upload_bucket_var,
      ATHENA_BUCKET = var.athena_bucket_var,
      DATABASE = var.database_var,
      FBAD_TABLE = var.fbad_table_var,
      GCM_STANDARD_TABLE = var.gcm_table_var,
      DOWNLOAD_BUCKET = var.download_bucket_var,
      GADSDISC_TABLE = var.gadsdisc_table_var,
      GADS_TABLE = var.gads_table_var,
      GADSPS_TABLE = var.gadsps_table_var,
      GCM_FLOODLIGHT_TABLE = var.gcm_floodlight_table_var,
      GCM_SA360_COST_RESPONSE_TABLE = var.gcm_sa360_cost_response_table_var,
      GCM_SA360_TRANSACTIONS_TABLE = var.gcm_sa360_transactions_table_var,
      AADS_TABLE = var.adobe_ad_cloud_table_var
    }
  }

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

# Configure invocation configuration for Process Lambda
resource "aws_lambda_function_event_invoke_config" "process_all" {
  function_name = aws_lambda_function.process_all.function_name
  maximum_retry_attempts = var.process_retry_attempts
}

# Create S3 bucket notification to invoke process lambda
resource "aws_s3_bucket_notification" "gadsdisc" {
  bucket = var.download_bucket_var
  lambda_function {
    lambda_function_arn = aws_lambda_function.process_all.arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "google_ads/GAdsDISC/"
    filter_suffix = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_process_s3]
}

# Allow S3 bucket notification to invoke process lambda
resource "aws_lambda_permission" "allow_process_s3" {
  statement_id  = "AllowExecutionFromS3ForGAdsDISC"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_all.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3rawbucket_arn
}

############### DOWNLOAD LAMBDA - ALL ####################
# This Lambda function downloads reports from data sources on a daily basis, storing the files
# in the raw bucket.

# Create template_file containing source code files
data "template_file" "download_file" {
  count = "${length(local.download_source_files)}"
  template = "${file(element(local.download_source_files, count.index))}"
}

# Automatically create zip package
data "archive_file" "download_zip" {
  type = "zip"
  output_path = var.download_package_path

  source {
    filename = "${basename(local.download_source_files[0])}"
    content = "${data.template_file.download_file.0.rendered}"
  }
  source {
    filename = "facebook_ads/${basename(local.download_source_files[1])}"
    content = "${data.template_file.download_file.1.rendered}"
  }
  source {
    filename = "google_ads/${basename(local.download_source_files[2])}"
    content = "${data.template_file.download_file.2.rendered}"
  }
  source {
    filename = "gcm/${basename(local.download_source_files[3])}"
    content = "${data.template_file.download_file.3.rendered}"
  }
  source {
    filename = "gcm/${basename(local.download_source_files[4])}"
    content = "${data.template_file.download_file.4.rendered}"
  }
  source {
    filename = "gcm/${basename(local.download_source_files[5])}"
    content = "${data.template_file.download_file.5.rendered}"
  }
  source {
    filename = "adobe_ad_cloud/${basename(local.download_source_files[6])}"
    content = "${data.template_file.download_file.6.rendered}"
  }
}

# Deploy Download Lambda function
resource "aws_lambda_function" "download_all" {
  filename = var.download_package_path
  source_code_hash = data.archive_file.download_zip.output_base64sha256
  function_name = var.download_all_function_name
  runtime = var.runtime
  role = var.role_arn
  handler = var.download_all_handler
  timeout = var.download_all_timeout
  memory_size = var.download_all_memory

  layers = [
    aws_lambda_layer_version.facebook_layer.arn,
    aws_lambda_layer_version.google_layer.arn
  ]

   #VPC configuration for download all lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      DOWNLOAD_BUCKET = var.download_bucket_var,
      FBAD_CREDENTIALS = var.fbad_credentials_var,
      FBAD_PARAMS = var.fbad_params_var,
      FBAD_FIELDS = var.fbad_fields_var,
      GAD_CREDENTIALS = var.gad_credentials_var,
      GAD_REPORTS = var.gad_reports_var,
      # FY_20_ALL_Campaigns_Discovery_QUERY = var.gad_disc_query_var, # NOTE: not being used right now due to API limitations
      FY_20_ALL_Campaigns_QUERY = var.gad_query_var,
      PaidSearch_Weekly_for_PM_QUERY = var.gad_ps_query_var,
      ENVIRONMENT        = var.environment_tag,
      DOWNLOAD_TOPIC_ARN = var.sns_topic_arn,
      ROOT_PARAMETER     = var.gcm_root_parameter,
      UPLOAD_BUCKET      = var.upload_bucket_var,
      ADOBE_AD_CREDENTIALS = var.adobe_ad_cloud_credentials_var
    }
  }

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

# Allow SNS to execute downloading Lambda function
resource "aws_lambda_permission" "allow_download_sns" {
  statement_id  = "AllowExecutionFromSNSForGCM"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.download_all.arn
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

# Allow CloudWatch Event to execute downloading Lambda function
resource "aws_lambda_permission" "allow_download_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatchForDownload"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.download_all.arn
  principal     = "events.amazonaws.com"
  source_arn    = var.download_rule_arn
}

##### DISASTER RECOVERY - BACKUP PARAMETERS #####
# Perform daily backups of NonSecure parameter strings to DR region

# Archive parameter backup Lambda code
data "archive_file" "backup_param_zip" {
  type        = "zip"
  source_file = "../lambdas/backup_parameters/backup_nonsecure_params.py"
  output_path = "backup_params.zip"
}

# Deploy parameter backup Lambda function
resource "aws_lambda_function" "backup_param" {
  filename = var.backup_param_lambda_package
  source_code_hash = data.archive_file.backup_param_zip.output_base64sha256
  function_name = var.backup_param_function_name
  runtime = var.runtime
  role = var.param_role_arn
  handler = var.backup_param_handler_name

  timeout = var.backup_param_timeout
  memory_size = var.backup_param_memory

  #VPC configuration for backup_param lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  environment {
    variables = {
      DR_REGION = var.dr_region
    }
  }

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

# Allow CloudWatch Event to Trigger Parameter Backup Lambda function
resource "aws_lambda_permission" "allow_cloudwatch_backup_param" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backup_param.arn
  principal     = "events.amazonaws.com"
  source_arn    = var.backup_param_rule_arn
}

######### GCM MONITOR LAMBDA ###############

# Create template_file containing source code files
data "template_file" "monitor_file" {
  count = "${length(local.gcm_monitor_source_files)}"
  template = "${file(element(local.gcm_monitor_source_files, count.index))}"
}

# Automatically create zip package
data "archive_file" "monitor_zip" {
  type = "zip"
  output_path = var.monitor_package_path

  source {
    filename = "${basename(local.gcm_monitor_source_files[0])}"
    content = "${data.template_file.monitor_file.0.rendered}"
  }
  source {
    filename = "gcm/${basename(local.gcm_monitor_source_files[1])}"
    content = "${data.template_file.monitor_file.1.rendered}"
  }
  source {
    filename = "gcm/${basename(local.gcm_monitor_source_files[2])}"
    content = "${data.template_file.monitor_file.2.rendered}"
  }
}

# Deploy monitoring Lambda function for GCM ingestion
resource "aws_lambda_function" "monitor" {
  filename      = var.monitor_package_path
  source_code_hash = data.archive_file.monitor_zip.output_base64sha256
  function_name = var.monitor_function_name
  runtime       = var.runtime
  role          = var.role_arn
  handler       = var.monitor_handler_name

  timeout     = var.monitor_timeout
  memory_size = var.monitor_memory_size

  layers = [aws_lambda_layer_version.awswrangler_layer.arn, aws_lambda_layer_version.common_layer.arn]

 #VPC configuration for monitor lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  environment {
    variables = {
      ENVIRONMENT        = var.environment_tag,
      DOWNLOAD_TOPIC_ARN = var.sns_topic_arn,
      ROOT_PARAMETER     = var.gcm_root_parameter,
      UPLOAD_BUCKET      = var.upload_bucket_id,
      DOWNLOAD_BUCKET    = var.bucket_id
    }
  }

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}


# Allow CloudWatch Event to execute monitoring Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.monitor.arn
  principal     = "events.amazonaws.com"
  source_arn    = var.rule_arn
}

########### GCM EXTRACT LAMBDA ################

# Create template_file containing source code files
data "template_file" "extract_file" {
  count = "${length(local.gcm_extract_source_files)}"
  template = "${file(element(local.gcm_extract_source_files, count.index))}"
}

# Automatically create zip package
data "archive_file" "extract_zip" {
  type = "zip"
  output_path = var.extract_package_path

  source {
    filename = "${basename(local.gcm_extract_source_files[0])}"
    content = "${data.template_file.extract_file.0.rendered}"
  }
  source {
    filename = "gcm/${basename(local.gcm_extract_source_files[1])}"
    content = "${data.template_file.extract_file.1.rendered}"
  }
  source {
    filename = "gcm/${basename(local.gcm_extract_source_files[2])}"
    content = "${data.template_file.extract_file.2.rendered}"
  }
  source {
    filename = "gcm/${basename(local.gcm_extract_source_files[3])}"
    content = "${data.template_file.extract_file.3.rendered}"
  }
  source {
    filename = "gcm/${basename(local.gcm_extract_source_files[4])}"
    content = "${data.template_file.extract_file.4.rendered}"
  }
}

# Deploy extracting Lamdba function for GCM ingestion
resource "aws_lambda_function" "extract" {
  filename      = var.extract_package_path
  function_name = var.extract_function_name
  source_code_hash = data.archive_file.extract_zip.output_base64sha256
  runtime       = var.runtime
  role          = var.role_arn
  handler       = var.extract_handler_name

  timeout     = var.extract_timeout
  memory_size = var.extract_memory_size

  layers = [aws_lambda_layer_version.awswrangler_layer.arn, aws_lambda_layer_version.common_layer.arn]

  #VPC configuration for Extract lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  environment {
    variables = {
      ENVIRONMENT        = var.environment_tag,
      DOWNLOAD_TOPIC_ARN = var.sns_topic_arn,
      ROOT_PARAMETER     = var.gcm_root_parameter,
      UPLOAD_BUCKET      = var.upload_bucket_id,
      DOWNLOAD_BUCKET    = var.bucket_id,
      CRITERIA           = var.gcm_extract_criteria_env_variable
    }
  }

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

############ ATHENA PARTITION REPAIR LAMBDA ##############
# This automatically loads new partitions output from the Process Lambda into the Glue tables

# Create template_file containing source code files
data "template_file" "athena_file" {
  count = "${length(local.athena_source_files)}"
  template = "${file(element(local.athena_source_files, count.index))}"
}

# Automatically create zip package
data "archive_file" "athena_zip" {
  type = "zip"
  output_path = var.athena_package_path

  source {
    filename = "${basename(local.athena_source_files[0])}"
    content = "${data.template_file.athena_file.0.rendered}"
  }
}

# Deploy Athena Lambda function to load partitions into Glue tables once processing Lambdas finish converting data
resource "aws_lambda_function" "athena" {
  filename      = var.athena_package_path
  function_name = var.athena_function_name
  source_code_hash = data.archive_file.athena_zip.output_base64sha256
  runtime       = var.runtime
  role          = var.role_arn
  handler       = var.athena_handler_name

 #VPC config for Athena Lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  tags = { 
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

############ HISTORICAL LAMBDA ##################
# This Lambda function looks at the specified data source with a given historical date range
# and downloads raw CSV files to S3.

# Create template_file containing source code files
data "template_file" "historical_file" {
  count = "${length(local.historical_source_files)}"
  template = "${file(element(local.historical_source_files, count.index))}"
}

# Automatically create zip package
data "archive_file" "historical_zip" {
  type = "zip"
  output_path = var.historical_package_path

  source {
    filename = "${basename(local.historical_source_files[0])}"
    content = "${data.template_file.historical_file.0.rendered}"
  }
  source {
    filename = "facebook_ads/${basename(local.historical_source_files[1])}"
    content = "${data.template_file.historical_file.1.rendered}"
  }
  source {
    filename = "google_ads/${basename(local.historical_source_files[2])}"
    content = "${data.template_file.historical_file.2.rendered}"
  }
  source {
    filename = "adobe_ad_cloud/${basename(local.historical_source_files[3])}"
    content = "${data.template_file.historical_file.3.rendered}"
  }
}

# Deploy historical download Lambda function
resource "aws_lambda_function" "historical" {
  filename      = var.historical_package_path
  function_name = var.historical_function_name
  source_code_hash = data.archive_file.historical_zip.output_base64sha256
  runtime       = var.runtime
  role          = var.role_arn
  handler       = var.historical_handler_name

  timeout     = var.historical_timeout
  memory_size = var.historical_memory

  layers = [
    aws_lambda_layer_version.facebook_layer.arn,
    aws_lambda_layer_version.google_layer.arn
  ]

 #VPC config for Historical Lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  environment {
    variables = {
      DATE_RANGE      = var.date_range,
      DOWNLOAD_BUCKET = var.download_bucket_var,
      FBAD_CREDENTIALS = var.fbad_credentials_var,
      FBAD_FIELDS = var.fbad_fields_var,
      FBAD_PARAMS = var.fbad_params_var,
      FY_20_ALL_Campaigns_Discovery_QUERY = var.gadsdisc_hist_query_var,
      FY_20_ALL_Campaigns_QUERY = var.gads_hist_query_var,
      PaidSearch_Weekly_for_PM_QUERY = var.gadsps_hist_query_var,
      GAD_CREDENTIALS = var.gad_credentials_var,
      GAD_REPORTS = var.gad_reports_var,
      ADOBE_AD_CREDENTIALS = var.adobe_ad_cloud_credentials_var
    }
  }

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

############ S3 ACCESS REPORTING #################

# Automatically create zip package
data "archive_file" "s3_access_reporting_zip" {
  type        = "zip"
  source_file = "../lambdas/s3_access_reporting/s3_access_reporting.py"
  output_path = "s3_access_reporting.zip"
}

# Deploy S3 Access Reporting Lambda function
resource "aws_lambda_function" "s3_access_reporting" {
  filename         = var.s3_access_reporting_lambda_package
  source_code_hash = data.archive_file.s3_access_reporting_zip.output_base64sha256
  function_name    = var.s3_access_reporting_function_name
  runtime          = var.runtime
  role             = var.role_arn
  handler          = var.s3_access_reporting_handler_name
  timeout          = var.s3_access_reporting_timeout
  memory_size      = var.s3_access_reporting_memory_size

  #VPC config for S3_Access_Reporting Lambda
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  environment {
    variables = {
      DATABASE_NAME = var.s3_access_reporting_database_name,
      BUCKET_NAME   = var.s3_access_reporting_bucket_name
    }
  }

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service_hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

# Allow CloudWatch Event to Trigger S3 Access Reporting Lambda function
resource "aws_lambda_permission" "allow_cloudwatch_s3_access_reporting" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_access_reporting.arn
  principal     = "events.amazonaws.com"
  source_arn    = var.s3_access_reporting_rule_arn
}
