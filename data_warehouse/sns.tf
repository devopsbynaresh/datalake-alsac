resource "aws_sns_topic" "redshift-diskspace-cloudwatch-alarms-topic-sns" {
  name = "redshift-diskspace-cloudwatch-alarms-topic-sns"
}

resource "aws_sns_topic" "redshift-healthstatus-cloudwatch-alarms-topic-sns" {
  name = "redshift-healthstatus-cloudwatch-alarms-topic-sns"
}

resource "aws_sns_topic" "redshift-maintenancemode-cloudwatch-alarms-topic-sns" {
  name = "redshift-maintenancemode-cloudwatch-alarms-topic-sns"
  display_name = "Maintenance is being performed on Redshift cluster"
}

resource "aws_sns_topic" "dms-cpuutilization-cloudwatch-alarms-topic-sns" {
  name = "dms-cpuutilization-cloudwatch-alarms-topic-sns"
}

resource "aws_sns_topic" "dms-cdcsourcelatency-cloudwatch-alarms-topic-sns" {
  name = "dms-cdcsourcelatency-cloudwatch-alarms-topic-sns"
}

resource "aws_sns_topic" "dms-cdctargetlatency-cloudwatch-alarms-topic-sns" {
  name = "dms-cdctargetlatency-cloudwatch-alarms-topic-sns"
}

resource "aws_sns_topic" "dms-cdcchangesdisksource-cloudwatch-alarms-topic-sns" {
  name = "dms-cdcchangesdisksource-cloudwatch-alarms-topic-sns"
}

resource "aws_sns_topic" "dms-cdcchangesdisktarget-cloudwatch-alarms-topic-sns" {
  name = "dms-cdcchangesdisktarget-cloudwatch-alarms-topic-sns"
}

resource "aws_sns_topic" "dms-migration-task-failure-event-subscription" {
  name = "dms-migration-task-failure-event-subscription"
}

resource "aws_sns_topic" "glue-bidb-etl-job-failure-eventbridge-topic-sns" {
  name = "glue-bidb-etl-job-failure-eventbridge-topic-sns"
  display_name = "ETL glue job failed"
}

resource "aws_sns_topic" "glue-bidb-etl-job-success-eventbridge-topic-sns" {
  name = "glue-bidb-etl-job-success-eventbridge-topic-sns"
}