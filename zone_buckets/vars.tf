variable "bucket" {
  description = "The Terraform state bucket name."
  type        = string
  default     = ""
}
variable "region" {
  description = "The region of the Terraform state bucket."
  type        = string
  default     = ""
}
variable "key" {
  description = "The Terraform state file name."
  type        = string
  default     = ""
}
variable "dynamodb_table" {
  description = "The Terraform state locking DynamoDB table."
  type        = string
  default     = ""
}

variable "env" {
  description = "Name of environment to use in naming convention of resources."
  type        = string
  default     = ""
}

variable "account_id" {
  description = "Account ID of AWS account"
  type = string
  default = ""
}
