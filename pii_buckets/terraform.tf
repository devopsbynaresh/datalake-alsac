terraform {
  backend "s3" {
    bucket         = "alsac-tfstate-prod"
    key            = "data-lake-production/pii_buckets.tf"
    region         = "us-east-1"
    dynamodb_table = "alsac-tfstate-lock-prod"
    encrypt        = true
    # profile        = "saml"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  # profile = "saml"
}
