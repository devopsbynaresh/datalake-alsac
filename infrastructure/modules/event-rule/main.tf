##### CloudWatch Scheduled Event for GCM Monitor Lambda #####
resource "aws_cloudwatch_event_rule" "monitor_lambda_trigger" {
  name                = var.name
  description         = var.description
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.monitor_lambda_trigger.name
  target_id = var.target_id
  arn       = var.monitor_lambda_arn
}

##### CloudWatch Scheduled Event for Download Lambda #####
resource "aws_cloudwatch_event_rule" "download_all_lambda_trigger" {
  name = var.download_lambda_name
  description = var.download_lambda_description
  schedule_expression = var.download_lambda_schedule
}

resource "aws_cloudwatch_event_target" "download_lambda" {
  rule = aws_cloudwatch_event_rule.download_all_lambda_trigger.name
  target_id = var.download_target_id
  arn = var.download_lambda_arn
}

##### CloudWatch Scheduled Event for S3 access reporting Lambda #####
resource "aws_cloudwatch_event_rule" "s3_access_reporting_lambda_trigger" {
  name                = var.s3_access_reporting_name
  description         = var.s3_access_reporting_description
  schedule_expression = var.s3_access_reporting_schedule
}

resource "aws_cloudwatch_event_target" "s3_access_reporting" {
  rule      = aws_cloudwatch_event_rule.s3_access_reporting_lambda_trigger.name
  target_id = var.s3_access_reporting_target_id
  arn       = var.s3_access_reporting_lambda_arn
}

##### CloudWatch Scheduled Event for Parameter backup Lambda #####
resource "aws_cloudwatch_event_rule" "backup_param_lambda_trigger" {
  name = var.backup_param_name
  description = var.backup_param_description
  schedule_expression = var.backup_param_schedule
}

resource "aws_cloudwatch_event_target" "backup_param" {
  rule = aws_cloudwatch_event_rule.backup_param_lambda_trigger.name
  target_id = var.backup_param_target_id
  arn = var.backup_param_lambda_arn
}
