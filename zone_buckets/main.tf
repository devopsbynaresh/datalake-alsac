#### PROVIDER INFO ####
provider "aws" {
  region  = var.region
  version = "~> 2.56"

  # Change profile to "saml" if you are using saml2aws and have the default profile ("saml") configured
  profile = "alsac"
}

#### TERRAFORM BACKEND ####
# This sets up the backend for Terraform to ensure the state file is centralized and doesn't get corrupted
# if multiple developers are deploying these Terraform scripts.
terraform {
  backend "s3" {
    # Change profile to "saml" if you are using saml2aws and have the default profile ("saml") configured
    profile = "alsac"
  }
}

#### S3 BUCKETS - NEW NAMING CONVENTION ####
# The following creates the same S3 buckets and corresponding policies to match the new naming convention:
# alsac-<env>-dla-<zone>

# Create S3 bucket for logging data
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "log_bucket_naming" {
  bucket        = "alsac-${var.env}-dla-log"
  acl           = "log-delivery-write"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 0
    enabled                                = true
    id                                     = "redshift-audit-logs"
    prefix                                 = "redshift-audit-logs/"
    tags                                   = {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }





  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::alsac-${var.env}-dla-log"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alsac-${var.env}-dla-log/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "Put bucket policy needed for audit logging",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::193672423079:user/logs"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alsac-${var.env}-dla-log/*"
        },
        {
            "Sid": "Get bucket policy needed for audit logging ",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::193672423079:user/logs"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::alsac-${var.env}-dla-log"
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alsac-${var.env}-dla-log/*",
            "Condition": {
                "Null": { "s3:x-amz-server-side-encryption":"true" },
                "Bool": { "aws:SecureTransport": "false" }
            }
        }
    ]
}
POLICY

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }

}

resource "aws_s3_bucket_metric" "log_bucket_metrics" {
  bucket = aws_s3_bucket.log_bucket_naming.bucket
  name   = "EntireBucket"
}

# Create bucket for raw data
resource "aws_s3_bucket" "b_naming" {
  bucket        = "alsac-${var.env}-dla-raw"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule {
    enabled = true
    id      = "archive_to_glacier"

    transition {
      days          = 365
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 365
    }
  }

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }
}
resource "aws_s3_bucket_policy" "raw_bucket_policy" {
  bucket = aws_s3_bucket.b_naming.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "RawBucketPolicy",
    "Statement": [
        {
            "Sid": "CrossAccountAccess-Raw",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:sts::566421363352:assumed-role/prod-ReadOnlyUser/hubbardc",
                    "arn:aws:sts::566421363352:assumed-role/prod-ReadOnlyUser/nguyend"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::alsac-${var.env}-dla-raw/*",
                "arn:aws:s3:::alsac-${var.env}-dla-raw"
            ]
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alsac-${var.env}-dla-raw/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_metric" "raw_bucket_metrics" {
  bucket = aws_s3_bucket.b_naming.bucket
  name   = "EntireBucket"
}

# Create bucket for curated data
resource "aws_s3_bucket" "curated_naming" {
  bucket        = "alsac-${var.env}-dla-curated"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }
}

# Data source for curated S3 bucket
data "aws_s3_bucket" "curated_data_naming" {
  bucket     = "alsac-${var.env}-dla-curated"
  depends_on = [aws_s3_bucket.curated_naming]
}

# Create bucket for Athena query results
resource "aws_s3_bucket" "athena_bucket_naming" {
  bucket        = "alsac-${var.env}-dla-aws-athena-query-results"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }
}

# Apply bucket policy: block public access for bucket containing pulled data
resource "aws_s3_bucket_public_access_block" "block_public_main_naming" {
  bucket = aws_s3_bucket.b_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Apply bucket policy: block public access for bucket containing transformed data
resource "aws_s3_bucket_public_access_block" "block_public_curated_naming" {
  bucket = aws_s3_bucket.curated_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Apply bucket policy: block public access for bucket containing Athena query results
resource "aws_s3_bucket_public_access_block" "block_public_athena_naming" {
  bucket = aws_s3_bucket.athena_bucket_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Apply bucket policy: block public access for bucket containing CloudTrail logs
resource "aws_s3_bucket_public_access_block" "block_public_logs_naming" {
  bucket = aws_s3_bucket.log_bucket_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create S3 bucket for landing zone
resource "aws_s3_bucket" "landing_naming" {
  bucket        = "alsac-${var.env}-dla-landing"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }
}

# Apply bucket policy: block public access for landing zone
resource "aws_s3_bucket_public_access_block" "block_public_landing_naming" {
  bucket = aws_s3_bucket.landing_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create S3 bucket for structured zone
resource "aws_s3_bucket" "structured_naming" {
  bucket        = "alsac-${var.env}-dla-structured"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 0
    enabled                                = true
    id                                     = "BIDB-to-IA"
    prefix                                 = "BIDB/"
    tags                                   = {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }
}
resource "aws_s3_bucket_policy" "structured_bucket_policy" {
  bucket = aws_s3_bucket.structured_naming.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "StructuredBucketPolicy",
    "Statement": [
        {
            "Sid": "CrossAccountAccess-Structured",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:sts::566421363352:assumed-role/prod-ReadOnlyUser/nguyend",
                    "arn:aws:sts::566421363352:assumed-role/prod-ReadOnlyUser/hubbardc"
                ]
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::alsac-${var.env}-dla-structured/*",
                "arn:aws:s3:::alsac-${var.env}-dla-structured"
            ]
        },
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alsac-${var.env}-dla-structured/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}

# Apply bucket policy: block public access for structured zone
resource "aws_s3_bucket_public_access_block" "block_public_structured_naming" {
  bucket = aws_s3_bucket.structured_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_metric" "structured_bucket_metrics" {
  bucket = aws_s3_bucket.structured_naming.bucket
  name   = "EntireBucket"
}

# Create S3 bucket for consumption zone
resource "aws_s3_bucket" "consumption_naming" {
  bucket        = "alsac-${var.env}-dla-consumption"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }
}

# Apply bucket policy: block public access for consumption zone
resource "aws_s3_bucket_public_access_block" "block_public_consumption_naming" {
  bucket = aws_s3_bucket.consumption_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create S3 bucket for sandbox
resource "aws_s3_bucket" "sandbox_naming" {
  bucket        = "alsac-${var.env}-dla-sandbox"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = "${var.env}"
    Role           = ""
    CreateDate     = "2020-05-06"
    CreateBy       = ""
    LineOfBusiness = "NA"
    Customer       = "US"
    CostCenter     = "5760 4560 5418"
    Approver       = ""
    LifeSpan       = ""
    Service-Hours  = ""
    Compliance     = ""
    ProjectTeam    = "datalake"
  }
}

# Apply bucket policy: block public access for sandbox zone
resource "aws_s3_bucket_public_access_block" "block_public_sandbox_naming" {
  bucket = aws_s3_bucket.sandbox_naming.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
