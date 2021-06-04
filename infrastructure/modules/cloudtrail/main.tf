resource "aws_cloudtrail" "s3_object_logs_trail" {
  name = var.name
  s3_bucket_name = var.s3_bucket_name
  include_global_service_events = false
  enable_log_file_validation = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  tags = {
    Name = var.name_tag
    Application = var.application_name_tag
    OwnerEmail = var.owneremail_tag
    Environment = var.environment_tag
    Role = var.role_tag
    CreateDate = var.createdate_tag
    CreateBy = var.createby_tag
    LineOfBusiness = var.lineofbusiness_tag
    Customer = var.customer_tag
    CostCenter = var.costcenter_tag
    Approver = var.approver_tag
    LifeSpan = var.lifespan_tag
    Service-Hours = var.service_hours_tag
    Compliance = var.compliance_tag
    ProjectTeam = var.project_team
  }
}
