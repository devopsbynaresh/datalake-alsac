 resource "aws_cloudwatch_event_rule" "RS-ETL-StepFunction-Scheduler-Daily" {
  name        = "RS-ETL-StepFunction-Scheduler-Daily"
  description = "Kicks of Redshift ETL StepFunction Daily at midnight"
  is_enabled = false
  schedule_expression = "cron(0 06 ? * MON-FRI *)"
}

resource "aws_cloudwatch_metric_alarm" "dev-datawarehouse-core-redshift-PercentageDiskSpaceUsed-ALL-alarm" {
  alarm_name                = "dev-datawarehouse-core-redshift-PercentageDiskSpaceUsed-ALL-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "10"
  metric_name               = "PercentageDiskSpaceUsed"
  namespace                 = "AWS/Redshift"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "redshift-dev-datawarehouse-core-redshift cluster has a greater than 90% disk space used alarm"
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:redshift-diskspace-cloudwatch-alarms-topic-sns"]
  insufficient_data_actions = []
    dimensions = {
    "ClusterIdentifier" = "dev-datawarehouse-core-redshift"
  }
}

resource "aws_cloudwatch_metric_alarm" "dev-datawarehouse-core-redshift-HealthStatus-ALL-alarm" {
  alarm_name                = "dev-datawarehouse-core-redshift-HealthStatus-ALL-alarm"
  comparison_operator       = "LessThanThreshold"
  datapoints_to_alarm       = "10"
  evaluation_periods        = "10"
  metric_name               = "HealthStatus"
  namespace                 = "AWS/Redshift"
  period                    = "60"
  statistic                 = "Minimum"
  threshold                 = "1"
  alarm_description         = "Triggers an alarm if the  health status of the cluster is less than 1."
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:redshift-healthstatus-cloudwatch-alarms-topic-sns"]
  insufficient_data_actions = []
    dimensions = {
    "ClusterIdentifier" = "dev-datawarehouse-core-redshift"
  }
}


resource "aws_cloudwatch_metric_alarm" "dev-datawarehouse-core-redshift-MaintenanceMode-ALL-alarm" {
  alarm_name                = "dev-datawarehouse-core-redshift-MaintenanceMode-ALL-alarm"
  comparison_operator       = "GreaterThanThreshold"
  datapoints_to_alarm       = "10"
  evaluation_periods        = "10"
  metric_name               = "MaintenanceMode"
  namespace                 = "AWS/Redshift"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "0"
  alarm_description         = "Triggers an alarm if the maintenance mode status of the cluster is greater than 0 for 10 data points within 10 minutes."
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:redshift-maintenancemode-cloudwatch-alarms-topic-sns"]
  insufficient_data_actions = []
    dimensions = {
    "ClusterIdentifier" = "dev-datawarehouse-core-redshift"
  }
}


resource "aws_cloudwatch_metric_alarm" "dev-bidbqa-sqlserver-awsdms-cdc-largetables-instance-cpuutilization-alarm" {
  alarm_name                = "dev-bidbqa-sqlserver-awsdms-cdc-largetables-instance-cpuutilization-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm       = "15"
  evaluation_periods        = "15"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/DMS"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = "100"
  alarm_description         = "Triggers an alarm if the CPU Utilization on the replication instance is 100% or greater for 15 data points within 15 minutes."
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:dms-cpuutilization-cloudwatch-alarms-topic-sns"]
  treat_missing_data        = "missing"
  insufficient_data_actions = []
    dimensions = {
    "ReplicationInstanceIdentifier" = "bidbqa-sqlserver-awsdms-cdc-largetables-instance",
    "ReplicationTaskIdentifier"     = "WOMTMK2K47ABTAYGFH6XY6DP5IB24XXQKKGDE7I"
  }
}


resource "aws_cloudwatch_metric_alarm" "dev-cdc-migration-s3-task-dms-cdclatencysource-alarm" {
  alarm_name                = "dev-cdc-migration-s3-task-dms-cdclatencysource-alarm"
  comparison_operator       = "GreaterThanThreshold"
  datapoints_to_alarm       = "1"
  evaluation_periods        = "1"
  metric_name               = "CDCLatencySource"
  namespace                 = "AWS/DMS"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = "7200"
  alarm_description         = "Triggers an alarm if the source latency for the cdc-migration-s3-task DMS migration task is greater than 1 hour (3600 seconds)."
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:dms-cdcsourcelatency-cloudwatch-alarms-topic-sns"]
  treat_missing_data        = "missing"
  insufficient_data_actions = []
    dimensions = {
    "ReplicationInstanceIdentifier" = "bidbqa-sqlserver-awsdms-cdc-largetables-instance",
    "ReplicationTaskIdentifier"     = "WOMTMK2K47ABTAYGFH6XY6DP5IB24XXQKKGDE7I"
  }
}



resource "aws_cloudwatch_metric_alarm" "dev-cdc-migration-s3-task-dms-cdclatencytarget-alarm" {
  alarm_name                = "dev-cdc-migration-s3-task-dms-cdclatencytarget-alarm"
  comparison_operator       = "GreaterThanThreshold"
  datapoints_to_alarm       = "1"
  evaluation_periods        = "1"
  metric_name               = "CDCLatencyTarget"
  namespace                 = "AWS/DMS"
  period                    = "300"
  statistic                 = "Maximum"
  threshold                 = "7200"
  alarm_description         = "Triggers an alarm if the target latency for the cdc-migration-s3-task DMS migration task is greater than 1 hour (3600 seconds)."
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:dms-cdctargetlatency-cloudwatch-alarms-topic-sns"]
  treat_missing_data        = "missing"
  insufficient_data_actions = []
    dimensions = {
    "ReplicationInstanceIdentifier" = "bidbqa-sqlserver-awsdms-cdc-largetables-instance",
    "ReplicationTaskIdentifier"     = "WOMTMK2K47ABTAYGFH6XY6DP5IB24XXQKKGDE7I"
  }
}


resource "aws_cloudwatch_metric_alarm" "dev-cdc-migration-s3-task-dms-cdcchangesdisksource-alarm" {
  alarm_name                = "dev-cdc-migration-s3-task-dms-cdcchangesdisksource-alarm"
  comparison_operator       = "GreaterThanThreshold"
  datapoints_to_alarm       = "2"
  evaluation_periods        = "2"
  metric_name               = "CDCChangesDiskSource"
  namespace                 = "AWS/DMS"
  period                    = "3600"
  statistic                 = "Maximum"
  threshold                 = "100000"
  alarm_description         = "Triggers an alarm if the number of rows accumulating on disk and waiting to be committed from the source is greater than 100,000 for 2 data points within 2 hours."
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:dms-cdcchangesdisksource-cloudwatch-alarms-topic-sns"]
  treat_missing_data        = "missing"
  insufficient_data_actions = []
    dimensions = {
    "ReplicationInstanceIdentifier" = "bidbqa-sqlserver-awsdms-cdc-largetables-instance",
    "ReplicationTaskIdentifier"     = "WOMTMK2K47ABTAYGFH6XY6DP5IB24XXQKKGDE7I"
  }
}


resource "aws_cloudwatch_metric_alarm" "dev-cdc-migration-s3-task-dms-cdcchangesdisktarget-alarm" {
  alarm_name                = "dev-cdc-migration-s3-task-dms-cdcchangesdisktarget-alarm"
  comparison_operator       = "GreaterThanThreshold"
  datapoints_to_alarm       = "2"
  evaluation_periods        = "2"
  metric_name               = "CDCChangesDiskTarget"
  namespace                 = "AWS/DMS"
  period                    = "3600"
  statistic                 = "Maximum"
  threshold                 = "100000"
  alarm_description         = "Triggers an alarm if the number of rows accumulating on disk and waiting to be committed to the target is greater than 100,000 for 2 data points within 2 hours."
  alarm_actions             = ["arn:aws:sns:us-east-1:117183459779:dms-cdcchangesdisktarget-cloudwatch-alarms-topic-sns"]
  treat_missing_data        = "missing"
  insufficient_data_actions = []
    dimensions = {
    "ReplicationInstanceIdentifier" = "bidbqa-sqlserver-awsdms-cdc-largetables-instance",
    "ReplicationTaskIdentifier"     = "WOMTMK2K47ABTAYGFH6XY6DP5IB24XXQKKGDE7I"
  }
}


 resource "aws_cloudwatch_event_rule" "glue-etl-status-notification-event" {
  name        = "glue-etl-status-notification-event"
  description = "Sends alert to SNS topic if ETL glue jobs run status = Failed."
event_pattern = <<EOF
{
  "detail-type": [
    "Glue Job State Change"
  ],
  "source": [
    "aws.glue"
  ],
  "detail": {
    "jobName": [
      {
        "prefix": "bidb-"
      }
    ],
    "state": [
      "FAILED"
    ]
  }
}
EOF
}


resource "aws_cloudwatch_event_target" "glue-bidb-etl-job-failure-eventbridge-topic-sns" {
  rule      = "glue-etl-status-notification-event"
  target_id = "Ide9e2d960-f4f3-49a3-8111-7b68e784825f"
  arn       = "arn:aws:sns:us-east-1:117183459779:glue-bidb-etl-job-failure-eventbridge-topic-sns"
}



 resource "aws_cloudwatch_event_rule" "glue-etl-success-status-notification-event" {
  name        = "glue-etl-success-status-notification-event"
  description = "Sends alert to SNS topic once ETL process completes successfully."
event_pattern = <<EOF
{
  "detail-type": [
    "Glue Job State Change"
  ],
  "source": [
    "aws.glue"
  ],
  "detail": {
    "jobName": [
      "bidb-load-fact-procs"
    ],
    "state": [
      "SUCCEEDED"
    ]
  }
}
EOF
}


resource "aws_cloudwatch_event_target" "glue-bidb-etl-job-success-eventbridge-topic-sns" {
  rule      = "glue-etl-success-status-notification-event"
  target_id = "Id54b9553c-2e0b-4bfc-aad5-3fbc983b8e72"
  arn       = "arn:aws:sns:us-east-1:117183459779:glue-bidb-etl-job-success-eventbridge-topic-sns"
}
 
