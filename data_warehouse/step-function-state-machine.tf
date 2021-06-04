
resource "aws_sfn_state_machine" "Redshift-DW-ETL" {
  name     = "Redshift-DW-ETL"
  role_arn = var.step_run_glue_jobs

definition = <<EOF
{
  "Comment": "Redshift ETL Steps",
  "StartAt": "Glue - Load CDC Source Data",
  "States": {
    "Glue - Load CDC Source Data": {
  "Type": "Task",
  "Resource": "arn:aws:states:::glue:startJobRun.sync",
  "Parameters": {
    "JobName": "bidb-cdc-data-load-glue-job"
  },
  "Next": "Glue - Load Dimensions"
},
"Glue - Load Dimensions": {
  "Type": "Task",
  "Resource": "arn:aws:states:::glue:startJobRun.sync",
  "Parameters": {
    "JobName": "bidb-refresh-materialized-view"
  },
  "Next": "Glue - bidb-refresh-xref-tables"
},
"Glue - bidb-refresh-xref-tables": {
  "Type": "Task",
  "Resource": "arn:aws:states:::glue:startJobRun.sync",
  "Parameters": {
    "JobName": "bidb-refresh-xref-tables"
  },
  "Next": "Glue - Load Dimensions 2"
},
"Glue - Load Dimensions 2": {
  "Type": "Task",
  "Resource": "arn:aws:states:::glue:startJobRun.sync",
  "Parameters": {
    "JobName": "bidb-refresh-materialized-view"
  },
  "Next": "Glue - bidb-load-fact-procs"
},
"Glue - bidb-load-fact-procs": {
  "Type": "Task",
  "Resource": "arn:aws:states:::glue:startJobRun.sync",
  "End":true,
  "Parameters": {
    "JobName": "bidb-load-fact-procs"
  }
}
}
}
  EOF
}