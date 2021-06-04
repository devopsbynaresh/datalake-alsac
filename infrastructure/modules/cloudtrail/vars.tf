variable "name" {
  type = string
  description = "The name of the CloudTrail trail for S3 Object Events"
}

variable "s3_bucket_name" {
  type = string
  description = "Name of the S3 Object Events CloudTrail target log bucket."
}

variable "name_tag" {
  type = string
  description = "Resource Name - unique naming convention"
  default = ""
}

variable "application_name_tag" {
  type = string
  description = "Application Name - MRE|Cognos|MPSC..."
  default = ""
}

variable "owneremail_tag" {
  type = string
  description = "App/Product Owner - email address"
  default = ""
}

variable "environment_tag" {
  type = string
  description = "Application Stage - Common|Prod|Dev"
  default = ""
}

variable "role_tag" {
  type = string
  description = "Service Radius - Web|Data|Cache"
  default = ""
}

variable "createdate_tag" {
  type = string
  description = "Resource Creation - date"
  default = ""
}

variable "createby_tag" {
  type = string
  description = "Resource Created By - userid"
  default = ""
}

variable "lineofbusiness_tag" {
  type = string
  description = "Financial - global|APAC|NA|EU..."
  default = ""
}

variable "customer_tag" {
  type = string
  description = "Financial (same as country) - WW|UK|US..."
  default = ""
}

variable "costcenter_tag" {
  type = string
  description = "Code provided directly from Finance"
  default = ""
}

variable "approver_tag" {
  type = string
  description = "Financial - email address"
  default = ""
}

variable "lifespan_tag" {
  type = string
  description = "Financial - date to be reviewed"
  default = ""
}

variable "service_hours_tag" {
  type = string
  description = "Automation - FullTime|Weekdays..."
  default = ""
}

variable "compliance_tag" {
  type = string
  description = "Security - PCI|PII"
  default = ""
}

variable "project_team" {
  type = string
  description = "Project team in charge of the resource"
  default = ""
}
