# terraform {
#   backend "s3" {
#     bucket = "mybucket"
#     key    = "path/to/my/key"
#     region = "us-east-1"
#   }
# }

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.56"

  profile = "alsac"
}

resource "aws_iam_role" "reporting_lambda_role" {
  name = "reporting_lambda_role"

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
    Environment    = ""
    Role           = ""
    CreateDate     = ""
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


resource "aws_iam_policy" "reporting_lambda_policy" {
  name   = "reporting_lambda_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowedAthenaAndGlueActions",
      "Action": [
        "athena:*Query*",
        "glue:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "AllowedS3Actions",
      "Effect": "Allow",
      "Action": [
        "s3:List*",
        "s3:Get*",
        "s3:*Object"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.reporting_lambda_role.name
  policy_arn = aws_iam_policy.reporting_lambda_policy.arn
}

data "archive_file" "aws_access_reporting_zip" {
  type        = "zip"
  source_file = "./aws_access_reporting.py"
  output_path = "aws_access_reporting.zip"
}


# Deploy AWS Access Reporting Lambda function
resource "aws_lambda_function" "aws_access_reporting" {
  filename         = "aws_access_reporting.zip"
  source_code_hash = data.archive_file.aws_access_reporting_zip.output_base64sha256
  function_name    = "dla_aws_access_reporting"
  runtime          = "python3.8"
  role             = aws_iam_role.reporting_lambda_role.arn
  handler          = "aws_access_reporting.handler"
  timeout          = 300
  memory_size      = 256

  environment {
    variables = {
      DATABASE_NAME = "aws_access_reporting"
      BUCKET_NAME   = "alsac-dev-dla-log"
    }
  }

  tags = {
    Name           = ""
    Application    = ""
    OwnerEmail     = ""
    Environment    = ""
    Role           = ""
    CreateDate     = ""
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

resource "aws_cloudwatch_event_rule" "aws_access_reporting_lambda_trigger" {
  name                = "aws-access-reporting-trigger"
  description         = "CRON to run the AWS Access Reporting lambda every Tuesday at midnight UTC"
  schedule_expression = "cron(0 0 ? * 3 *)"
}

resource "aws_cloudwatch_event_target" "aws_access_reporting_lambda" {
  rule      = aws_cloudwatch_event_rule.aws_access_reporting_lambda_trigger.name
  target_id = "TriggerAWSAccessReporting"
  arn       = aws_lambda_function.aws_access_reporting.arn
}
