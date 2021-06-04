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


#### IAM ROLE FOR INFRASTRUCTURE TEAM ####
# This creates an IAM role for the infrastructure team.
# Currently allows the Slalom infrastructure team to assume this role.
# resource "aws_iam_role" "role" {
#   name = "sl_infra_team_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal" : {
#         "AWS": [
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-sl_data_team_role/udogiei",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/hubbardc",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/nguyend",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/yoond"
#         ]
#       },
#       "Effect": "Allow"
#     }
#   ]
# }
# EOF

#   tags = {
#     Name           = ""
#     Application    = ""
#     OwnerEmail     = ""
#     Environment    = "${var.env}"
#     Role           = ""
#     CreateDate     = "2020-05-06"
#     CreateBy       = ""
#     LineOfBusiness = "NA"
#     Customer       = "US"
#     CostCenter     = "5760 4560 5418"
#     Approver       = ""
#     LifeSpan       = ""
#     Service-Hours  = ""
#     Compliance     = ""
#     ProjectTeam    = "datalake"
#   }
# }


#### IAM POLICY FOR INFRASTRUCTURE ROLE ####
# This creates an IAM policy to attach to the infrastructure role. This only allows access
# to services needed for the underlying infrastructure of the data lake.
resource "aws_iam_policy" "policy" {
  name = "sl_infra_team_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "athena:*",
        "ecr:*",
        "ec2:*",
        "ecs:*",
        "elasticfilesystem:*",
        "elasticloadbalancing:*",
        "lambda:*",
        "cloudwatch:*",
        "redshift:*",
        "sns:*",
        "dynamodb:*",
        "dms:*",
        "secretsmanager:*",
        "iam:*",
        "events:*",
        "logs:*",
        "glue:*",
        "cloudformation:*",
        "ssm:*",
        "tag:*",
        "resource-groups:*",
        "resource-explorer:*",
        "cloudtrail:*",
        "cloudshell:*",
        "kms:ListAliases"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


#### POLICY ATTACHMENT FOR INFRASTRUCTURE ROLE ####
# This attaches the IAM policy to the infrastructure role.
# resource "aws_iam_role_policy_attachment" "attach" {
#   role       = aws_iam_role.role.name
#   policy_arn = aws_iam_policy.policy.arn
# }


#### IAM ROLE FOR DATA LAKE TEAM ####
# This creates an IAM role for the data lake team.
# Currently allows the Slalom infrastructure and data lake team to assume this role.
# resource "aws_iam_role" "data_role" {
#   name = "sl_data_team_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal" : {
#         "AWS": [
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/webba",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/nguyend",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/yoond",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/katariwalas",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/feldvebela"
#         ]
#       },
#       "Effect": "Allow"
#     }
#   ]
# }
# EOF

#   tags = {
#     Name           = ""
#     Application    = ""
#     OwnerEmail     = ""
#     Environment    = "${var.env}"
#     Role           = ""
#     CreateDate     = "2020-05-06"
#     CreateBy       = ""
#     LineOfBusiness = "NA"
#     Customer       = "US"
#     CostCenter     = "5760 4560 5418"
#     Approver       = ""
#     LifeSpan       = ""
#     Service-Hours  = ""
#     Compliance     = ""
#     ProjectTeam    = "datalake"
#   }
# }


#### IAM POLICY FOR DATA LAKE ROLE ####
# This creates an IAM policy to attach to the data lake role. This only allows access
# to services and actions needed for the data lake.
resource "aws_iam_policy" "data_policy" {
  name = "sl_data_team_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowedLambdaActions",
      "Effect": "Allow",
      "Action": [
        "lambda:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowedCloudWatchActions",
      "Effect": "Allow",
      "Action": [
        "cloudwatch:Describe*",
        "cloudwatch:List*",
        "cloudwatch:Get*",
        "events:*",
        "logs:Describe*",
        "logs:Get*",
        "logs:List*",
        "logs:StartQuery",
        "logs:StopQuery",
        "logs:TestMetricFilter",
        "logs:FilterLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MiscReadOnlyAccess",
      "Effect": "Allow",
      "Action": [
        "tag:GetResources",
        "iam:List*",
        "iam:PassRole",
        "iam:Get*",
        "kms:List*",
        "sns:List*",
        "sns:Get*",
        "cloudformation:DescribeStack*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowedGlueActions",
      "Effect": "Allow",
      "Action": [
        "glue:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowedS3Actions",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:PutObject",
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": "arn:aws:s3:::*",
      "Condition": {
        "StringEqualsIfExists": {
          "s3:ResourceTag/ProjectTeam": "datalake",
          "s3:ResourceTag/Environment": "${var.env}"
        }
      }
    },
    {
      "Sid": "AllowedAthenaActions",
      "Effect": "Allow",
      "Action": "athena:*",
      "Resource": "*"
    },
    {
      "Sid": "AllowedSSMParameterActions",
      "Effect": "Allow",
      "Action": [
        "ssm:*Parameter*",
        "ssm:Describe*",
        "ssm:AddTagsToResource",
        "ssm:RemoveTagsFromResource",
        "ssm:ListTagsForResource"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


#### POLICY ATTACHMENT FOR DATA LAKE ROLE ####
# This attaches the IAM policy to the data lake role.
# resource "aws_iam_role_policy_attachment" "data_attach" {
#   role       = aws_iam_role.data_role.name
#   policy_arn = aws_iam_policy.data_policy.arn
# }


#### IAM ROLE FOR DATA ANALYST ####
# This creates an IAM role for a data analyst who needs to run Athena queries.
# resource "aws_iam_role" "analyst_role" {
#   name = "sl_analyst_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "AWS": [
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/tuckera",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/nguyend",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/feldvebela",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/webba",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/katariwalas",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-ReadOnlyUser/yoond",
#           "arn:aws:sts::${var.account_id}:assumed-role/${var.env}-sl_data_team_role/wellsj"
#         ]
#       },
#       "Effect": "Allow"
#     }
#   ]
# }
# EOF
# }


#### IAM POLICY FOR DATA ANALYST ROLE ####
# This creates an IAM policy for the analyst role to allow Athena queries and read-only Glue access.
resource "aws_iam_policy" "analyst_policy" {
  name = "sl_analyst_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GlueViewOnly",
      "Effect": "Allow",
      "Action": [
        "glue:*Get*",
        "glue:List*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowedAthenaActions",
      "Effect": "Allow",
      "Action": [
        "athena:*Get*",
        "athena:List*",
        "athena:Start*",
        "athena:Stop*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowedS3Actions",
      "Effect": "Allow",
      "Action": [
        "s3:*Get*",
        "s3:*List*",
        "s3:*Describe*"
      ],
      "Resource": [
                "arn:aws:s3:::alsac-${var.env}-dla-aws-athena-query-results",
                "arn:aws:s3:::alsac-${var.env}-dla-consumption",
                "arn:aws:s3:::alsac-${var.env}-dla-curated",
                "arn:aws:s3:::alsac-${var.env}-dla-landing",
                "arn:aws:s3:::alsac-${var.env}-dla-raw",
                "arn:aws:s3:::alsac-${var.env}-dla-sandbox",
                "arn:aws:s3:::alsac-${var.env}-dla-structured",
                "arn:aws:s3:::alsac-${var.env}-dla-aws-athena-query-results/*",
                "arn:aws:s3:::alsac-${var.env}-dla-consumption/*",
                "arn:aws:s3:::alsac-${var.env}-dla-curated/*",
                "arn:aws:s3:::alsac-${var.env}-dla-landing/*",
                "arn:aws:s3:::alsac-${var.env}-dla-raw/*",
                "arn:aws:s3:::alsac-${var.env}-dla-sandbox/*",
                "arn:aws:s3:::alsac-${var.env}-dla-structured/*"
            ]
    },
    {
      "Sid": "AllowedS3PutOperations",
      "Effect": "Allow",
      "Action": [
        "s3:Put*"
      ],
      "Resource": [
        "arn:aws:s3:::alsac-${var.env}-dla-aws-athena-query-results",
        "arn:aws:s3:::alsac-${var.env}-dla-aws-athena-query-results/*",
        "arn:aws:s3:::alsac-${var.env}-dla-raw/google_ads/GAdsDISC/",
        "arn:aws:s3:::alsac-${var.env}-dla-raw/google_ads/GAdsDISC/*"
      ]
    },
    {
        "Sid": "S3ReadOnlyBuckets",
        "Effect": "Allow",
        "Action": [
            "s3:*Get*",
            "s3:*List*"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

#### POLICY ATTACHMENT FOR ANALYST ROLE ####
# This attaches the IAM policy to the analyst role.
# resource "aws_iam_role_policy_attachment" "analyst_attach" {
#   role       = aws_iam_role.analyst_role.name
#   policy_arn = aws_iam_policy.analyst_policy.arn
# }

#### IAM ROLE FOR LAMBDA ####
# This creates an IAM role for the Lambda functions.
# The policy is defined in the infrastructure Terraform scripts (../infrastructure/modules/lambda).
resource "aws_iam_role" "lambda_role" {
  name = "sl_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

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

#### IAM ROLE FOR LAMBDA ####
# This creates an IAM role for the Lambda functions.
# The policy is defined in the infrastructure Terraform scripts (../infrastructure/modules/lambda).
resource "aws_iam_role" "params_lambda_role" {
  name = "backup_params_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

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

#### IAM ROLE FOR WRITING TO CLOUDWAtCH LOGS ####
# This creates an IAM role for any service that needs to write to CloudWatch Logs.
resource "aws_iam_role" "logs_role" {
  name = "access_logs_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "sns.amazonaws.com",
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF

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

# Policy for role to allow writing to CloudWatch Logs
resource "aws_iam_policy" "logs_policy" {
  name   = "access_logs_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowedLogsActions",
      "Effect": "Allow",
      "Action": [
        "logs:*",
        "lambda:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach policy to CloudWatch Logs role
resource "aws_iam_role_policy_attachment" "logs_attach" {
  role       = aws_iam_role.logs_role.name
  policy_arn = aws_iam_policy.logs_policy.arn
}
