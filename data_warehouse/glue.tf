data "aws_ssm_parameter" "redshift-secret" {
  name = "redshift_creds"
}

locals {
  redshift_creds = jsondecode(
    data.aws_ssm_parameter.redshift-secret.value
  )
}

resource "aws_glue_job" "bidb-cdc-data-load-glue-job" {
  name     = "bidb-cdc-data-load-glue-job"
  role_arn = var.glue_s3_redshift_access_role
  connections = [ "bidb-dev-datawarehouse-core-redshift-glue-connection" ]
  default_arguments = {
    "--Secret"               = var.redshift_credentials_parameter_store
    "--job-bookmark-option"  = "job-bookmark-disable"
    "--job-language"         = "python"
    "--partition_end_date"   = "2020-12-12"
    "--partition_start_date" = "2020-12-12"
  }

  command {
    name            = "pythonshell"
    script_location = "s3://aws-glue-scripts-117183459779-us-east-1/admin/bidb-cdc-data-load-glue-job.py"
  }
}

resource "aws_glue_job" "bidb-load-fact-procs" {
  name     = "bidb-load-fact-procs"
  role_arn = var.glue_s3_redshift_access_role
  connections = [ "bidb-dev-datawarehouse-core-redshift-glue-connection" ]
  default_arguments = {
    "--Secret"               = var.redshift_credentials_parameter_store
    "--job-bookmark-option"  = "job-bookmark-disable"
    "--job-language"         = "python"
  }

  command {
    name            = "pythonshell"
    script_location = "s3://aws-glue-scripts-117183459779-us-east-1/admin/bidb-load-fact-procs.py"
  }
}


resource "aws_glue_job" "bidb-refresh-materialized-view" {
  name     = "bidb-refresh-materialized-view"
  role_arn = var.glue_s3_redshift_access_role
  connections = [ "bidb-dev-datawarehouse-core-redshift-glue-connection" ]
  default_arguments = {
    "--Secret"               = var.redshift_credentials_parameter_store
    "--job-bookmark-option"  = "job-bookmark-disable"
    "--job-language"         = "python"
  }

  command {
    name            = "pythonshell"
    script_location = "s3://aws-glue-scripts-117183459779-us-east-1/admin/bidb-refresh-materialized-view.py"
  }
}


resource "aws_glue_job" "bidb-refresh-xref-tables" {
  name     = "bidb-refresh-xref-tables"
  role_arn = var.glue_s3_redshift_access_role
  connections = [ "bidb-dev-datawarehouse-core-redshift-glue-connection" ]
  default_arguments = {
    "--Secret"               = var.redshift_credentials_parameter_store
    "--job-bookmark-option"  = "job-bookmark-disable"
    "--job-language"         = "python"
  }

  command {
    name            = "pythonshell"
    script_location = "s3://aws-glue-scripts-117183459779-us-east-1/admin/bidb-refresh-xref-tables.py"
  }
}


resource "aws_glue_connection" "bidb-dev-datawarehouse-core-redshift-glue-connection" {
connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:redshift://dev-datawarehouse-core-redshift.clhutcfjoa3r.us-east-1.redshift.amazonaws.com:1962/datawarehouse"
    PASSWORD            = local.redshift_creds.master_password
    USERNAME            = "dev-datawarehouse-core-master-user"
  }

  name = "bidb-dev-datawarehouse-core-redshift-glue-connection"

  physical_connection_requirements {
    availability_zone      = var.dw_availability_zone_1a
    security_group_id_list = [ "sg-0a7453f3b44a921ae"]
    subnet_id              = "subnet-01ffafbd540cf34e9"
  }
}