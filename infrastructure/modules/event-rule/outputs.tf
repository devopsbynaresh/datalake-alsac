output "event_rule_arn" {
  description = "The ARN of the GCM event rule"
  value       = aws_cloudwatch_event_rule.monitor_lambda_trigger.arn
}

output "s3_access_reporting_rule_arn" {
  description = "The ARN of the S3 access reporting event rule"
  value = aws_cloudwatch_event_rule.s3_access_reporting_lambda_trigger.arn
}

output "backup_param_rule_arn" {
  description = "The ARN of the parameter backup event rule"
  value = aws_cloudwatch_event_rule.backup_param_lambda_trigger.arn
}

output "download_event_rule_arn" {
  description = "The ARN of the Download Lambda event rule"
  value = aws_cloudwatch_event_rule.download_all_lambda_trigger.arn
}
