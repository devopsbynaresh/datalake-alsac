resource "aws_s3_bucket" "pii_raw_bucket" {
  bucket = "alsac-prod-dla-dev-shared-pii-raw"
  #   versioning {
  #     enabled = true
  #   }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(
    local.common_tags
  )
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "RawPIIBucketPolicy",
    "Statement": [
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "Access-to-specific-VPCE-only",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw/*",
            "Condition": {
                "StringNotEquals": {
                    "aws:sourceVpce": "vpce-09a406b02251d2664"
                }
            }
        },
        {
            "Sid": "AllowLambdas",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.dev_account_id}:role/alsac-managed/alsacLambdaPrdS3Access"
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:DeleteObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw",
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw/*"
            ]
        },
        {
            "Sid": "AllowStructuredLambdas",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.dev_account_id}:role/alsac-managed/alsacLambdaStructuredS3Access"
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw",
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw/*"
            ]
        },
        {
            "Sid": "AllowGlue",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.dev_account_id}:role/alsac-managed/alsacGluePrdS3Access"
            },
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw",
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw/*"
            ]
        },

        {
            "Sid": "AllowDataSync",
            "Effect": "Allow",
            "Principal" : {
                "AWS": [
                    "arn:aws:iam::${var.account_id}:role/prodFacebookCrossAccountDataSync",
                    "arn:aws:iam::${var.account_id}:role/service-role/AWSDataSyncS3BucketAccess-alsac-prod-dla-dev-shared-pii-raw"
                ]
            },
            "Action" : [
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource"  : [
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw",
                "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-raw/*"
            ]
        }
        
    ]
}
POLICY
}

resource "aws_s3_bucket" "pii_raw_cwp_bucket" {
  bucket = "alsac-prod-dla-dev-shared-pii-curated"
  #   versioning {
  #     enabled = true
  #   }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(
    local.common_tags
  )
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "RawPIIBucketPolicy",
    "Statement": [
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-curated/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "Access-to-specific-VPCE-only",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-curated/*",
            "Condition": {
                "StringNotEquals": {
                    "aws:sourceVpce": "vpce-09a406b02251d2664"
                }
            }
        },
        {
            "Sid": "AllowLambas",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.dev_account_id}:role/alsac-managed/alsacLambdaPrdS3Access"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::alsac-prod-dla-dev-shared-pii-curated/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "aws-glue-scripts" {
  bucket = "aws-glue-scripts-${var.account_id}-us-east-1"
  #   versioning {
  #     enabled = true
  #   }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(
    local.common_tags
  )
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "RawPIIBucketPolicy",
    "Statement": [
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::aws-glue-scripts-${var.account_id}-us-east-1/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        },
        {
            "Sid": "Access-to-specific-VPCE-only",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::aws-glue-scripts-${var.account_id}-us-east-1/*",
            "Condition": {
                "StringNotEquals": {
                    "aws:sourceVpce": "vpce-09a406b02251d2664"
                }
            }
        }
    ]
}
POLICY
}
