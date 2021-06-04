variable "lambda_topic_name" {
  type        = string
  description = "Name of SNS topic to trigger download all Lambda function"
}

variable "data_lake_team_topic_name" {
  type        = string
  description = "Name of SNS topic for Data Lake Team CloudWatch alarms"
}

variable "infrastructure_team_topic_name" {
  type        = string
  description = "Name of SNS topic for Infrastructure Team CloudWatch alarms"
}

variable "lambda_endpoint_arn" {
  type        = string
  description = "ARN of download all Lambda"
}

variable "role_arn" {
  type        = string
  description = "ARN of IAM role that allows an Amazon service to write to CloudWatch Logs"
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

variable "service-hours_tag" {
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
