output "lambda_topic_arn" {
  description = "ARN of download Lambda function"
  value = aws_sns_topic.lambda_topic.arn
}

output "lambda_topic_name" {
  description = "Name of GCM SNS topic"
  value = aws_sns_topic.lambda_topic.name
}

output "data_lake_team_topic_arn" {
  description = "ARN of SNS topic to alert Data Lake team"
  value = aws_sns_topic.data_lake_team_topic.arn
}

output "data_lake_team_topic_name" {
  description = "Name of SNS topic to alert Data Lake team"
  value = aws_sns_topic.data_lake_team_topic.name
}

output "infrastructure_team_topic_arn" {
  description = "ARN of SNS topic to alert Infrastructure team"
  value = aws_sns_topic.infrastructure_team_topic.arn
}

output "infrastructure_team_topic_name" {
  description = "Name of SNS topic to alert Infrastructure team"
  value = aws_sns_topic.infrastructure_team_topic.name
}
