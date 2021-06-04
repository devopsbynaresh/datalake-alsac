#### PROVIDER INFO ####
provider "aws" {
  profile = "saml"
  region  = "us-east-1"
}



#### TERRAFORM BACKEND ####
# This sets up the backend for Terraform to ensure the state file is centralized and doesn't get corrupted
# if multiple developers are deploying these Terraform scripts.
terraform {
  backend "s3" {
    bucket  = "alsac-tfstate-dev"
    key     = "redshift-development/infrastructure.tfstate"
    region  = "us-east-1"
    profile = "saml"
  }
}


#### AVAILABILITY ZONE VARIABLES ####
variable "dw_availability_zone_1a" {
  description = "us-east-1a availability zone used for DW deployment."
  type        = string
  default     = "us-east-1a"
}

variable "dw_availability_zone_1b" {
  description = "us-east-1b availability zone used for DW deployment."
  type        = string
  default     = "us-east-1b"
}


### IAM ROLES VARIABLES ###
variable "glue_s3_redshift_access_role" {
#  description = ""
  type        = string
  default     = "arn:aws:iam::117183459779:role/glue-s3-redshift-access-role"
}

variable "dms_s3_access_role" {
#  description = ""
  type        = string
  default     = "arn:aws:iam::117183459779:role/dms-s3-access-role"
}

variable "step_run_glue_jobs" {
#  description = ""
  type        = string
  default     = "arn:aws:iam::117183459779:role/alsac-managed/step-run-glue-jobs"
}


### VPC VARIABLES ###
variable "vpc_id" {
#  description = ""
  type        = string
  default     = "vpc-0b79fa82d06086bc3"
}


### SUBNET GROUP VARIABLES ###
variable "dms_replication_subnet_group" {
#  description = ""
  type        = string
  default     = "dms-subnet-group"
}

variable "redshift_subnet_group" {
#  description = ""
  type        = string
  default     = "redshift-private-subnet"
}


### SECURITY GROUP VARIABLES ###
variable "dms_security_group" {
#  description = ""
  type        = string
  default     = "sg-0017ca3022c82289d"
}

variable "redshift_security_group" {
#  description = ""
  type        = string
  default     = "sg-0a7453f3b44a921ae"
}


### BUCKET FOLDER VARIABLES ###
variable "s3_bidb_bucket_folder" {
  description = "S3 bucket folder for bidb data"
  type        = string
  default     = "BIDB"
}


### PARAMETER STORE VARIABLES ###
variable "redshift_credentials_parameter_store" {
#  description = ""
  type        = string
  default     = "redshift_creds"
}



