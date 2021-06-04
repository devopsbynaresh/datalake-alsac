# SNS topic for GCM download
resource "aws_sns_topic" "lambda_topic" {
  name = var.lambda_topic_name

  lambda_failure_feedback_role_arn = var.role_arn

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service-hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

data "aws_iam_policy_document" "lambda_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.lambda_topic.arn]
  }
}

# Subscribe download Lambda to GCM SNS topic
resource "aws_sns_topic_subscription" "lambda_triggers_lambda_target" {
  topic_arn = aws_sns_topic.lambda_topic.arn
  protocol  = "lambda"
  endpoint  = var.lambda_endpoint_arn
}

# SNS topic to alert Data Lake team
resource "aws_sns_topic" "data_lake_team_topic" {
  name = var.data_lake_team_topic_name

  application_failure_feedback_role_arn = var.role_arn
  http_failure_feedback_role_arn        = var.role_arn

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service-hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

data "aws_iam_policy_document" "data_lake_team_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.data_lake_team_topic.arn]
  }
}

# SNS topic to alert Infrastructure team
resource "aws_sns_topic" "infrastructure_team_topic" {
  name = var.infrastructure_team_topic_name

  application_failure_feedback_role_arn = var.role_arn
  http_failure_feedback_role_arn        = var.role_arn

  tags = {
    Name           = var.name_tag
    Application    = var.application_name_tag
    OwnerEmail     = var.owneremail_tag
    Environment    = var.environment_tag
    Role           = var.role_tag
    CreateDate     = var.createdate_tag
    CreateBy       = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer       = var.customer_tag
    CostCenter     = var.costcenter_tag
    Approver       = var.approver_tag
    LifeSpan       = var.lifespan_tag
    Service-Hours  = var.service-hours_tag
    Compliance     = var.compliance_tag
    ProjectTeam    = var.project_team
  }
}

data "aws_iam_policy_document" "infrastructure_team_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.infrastructure_team_topic.arn]
  }
}

