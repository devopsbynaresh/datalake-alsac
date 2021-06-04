variable "env" {
  description = "Name of environment to use in naming convention of resources."
  type        = string
  default     = ""
}

variable "account_id" {
  description = "Account ID of AWS account"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "Region where resources will be deployed"
  type        = string
  default     = ""
}

variable "s3_structured_bucket" {
  description = "S3 bucket for structured data"
  type        = string
    default     = ""
}

variable "s3_log_bucket" {
  description = "S3 bucket for log data"
  type        = string
    default     = ""
}