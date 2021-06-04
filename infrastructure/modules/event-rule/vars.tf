variable "name" {
  type        = string
  description = "Name of CloudWatch event rule for GCM"
}

variable "description" {
  type        = string
  description = "Description of event rule for GCM"
}

variable "schedule" {
  type        = string
  description = "Schedule expression for GCM event rule"
}

variable "target_id" {
  type        = string
  description = "GCM Target ID"
}

variable "monitor_lambda_arn" {
  type        = string
  description = "ARN of target Lambda function"
}

variable "download_lambda_name" {
  type = string
  description = "Name of Cloudwatch Event rule for Download lambda"
}

variable "download_target_id" {
  type = string
  description = "Target ID for CloudWatch Event rule for Download Lambda"
}

variable "download_lambda_arn" {
  type = string
  description = "ARN of Download lambda function"
}

variable "download_lambda_description" {
  type = string
  description = "Description of Cloudwatch Event rule for Download Lambda"
}

variable "download_lambda_schedule" {
  type = string
  description = "Schedule expression for Cloudwatch event rule for Download Lambda"
}

variable "s3_access_reporting_name" {
  type        = string
  description = "Name of CloudWatch Event rule for S3 access reporting"
}

variable "s3_access_reporting_description" {
  type        = string
  description = "Name of CloudWatch Event description for S3 access reporting"
}

variable "s3_access_reporting_schedule" {
  type        = string
  description = "Name of CloudWatch Event schedule for S3 access reporting"
}

variable "s3_access_reporting_target_id" {
  type        = string
  description = "Lambda target id"
}

variable "s3_access_reporting_lambda_arn" {
  type        = string
  description = "Lambda target ARN"
}

variable "backup_param_name" {
  type = string
  description = "Name of CloudWatch Event schedule for parameter backup Lambda"
}

variable "backup_param_description" {
  type = string
  description = "Description of CloudWatch Event schedule for parameter backup Lambda"
}

variable "backup_param_schedule" {
  type = string
  description = "Schedule for CloudWatch Event rule for parameter backup Lambda"
}

variable "backup_param_target_id" {
  type = string
  description = "ID for CloudWatch Event target for parameter backup"
}

variable "backup_param_lambda_arn" {
  type = string
  description = "ARN of parameter backup Lambda"
}
