variable "data_catalog_database_name" {
  type = string
  description = "Name of Glue database"
}

variable "fbad_table_name" {
  type = string
  description = "Name of Glue table for Facebook"
}

variable "gcm_table_name" {
  type = string
  description = "Name of Glue table for GCM standard"
}


variable "gcm_sa360_cost_response_table_name" {
  type = string
  description = "Name of the Glue table for GCM standard SA360 Cost response data"
}

variable "gcm_sa360_cost_response_table_location" {
  type = string
  description = "S3 location of GCM standard SA360 Cost response data"
}

variable "gcm_sa360_transactions_table_name" {
  type = string
  description = "Name of the Glue table for GCM standard SA360 transactions data"
}

variable "gcm_sa360_transactions_table_location" {
  type = string
  description = "S3 location of GCM standard SA360 transactions data"
}

variable "gcm_floodlight_table_name" {
  type = string
  description = "Name of Glue table for GCM floodlight"
}

variable "gcm_floodlight_table_location" {
  type = string
  description = "S3 location of GCM floodlight data"
}

variable "gads_table_name" {
  type = string
  description = "Name of Glue table for GAds"
}

variable "gadsdisc_table_name" {
  type = string
  description = "Name of Glue table for GAdsDISC"
}

variable "gadsps_table_name" {
  type = string
  description = "Name of Glue table for GAds PaidSearch"
}

variable "aac_table_name" {
  type = string
  description = "Name of Glue table for Adobe AdCloud"
}

variable "fbad_table_location" {
  type = string
  description = "S3 location of fbAd data"
}

variable "gcm_table_location" {
  type = string
  description = "S3 location of GCM standard data"
}

variable "gads_table_location" {
  type = string
  description = "S3 location of GAds data"
}

variable "gadsdisc_table_location" {
  type = string
  description = "S3 location of GAdsDISC data"
}

variable "gadsps_table_location" {
  type = string
  description = "S3 location of Gads PaidSearch data"
}

variable "adobe_ad_cloud_table_location" {
  type = string
  description = "S3 location of Adobe Ad Cloud data"
}

######## Resource Tagging ########

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

variable "service-hours_tag" {
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
