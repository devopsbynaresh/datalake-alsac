output "download_all_function_name" {
  description = "Name of download Lambda function"
  value = aws_lambda_function.download_all.function_name
}

output "download_all_function_arn" {
  description = "ARN of download Lambda function"
  value = aws_lambda_function.download_all.arn
}

output "monitor_function_name" {
  description = "Name of GCM monitor Lambda function"
  value = aws_lambda_function.monitor.function_name
}

output "monitor_function_arn" {
  description = "ARN of GCM Monitor Lambda function"
  value = aws_lambda_function.monitor.arn
}

output "process_function_name" {
  description = "Name of Process Lambda function"
  value = aws_lambda_function.process_all.function_name
}

output "process_function_arn" {
  description = "ARN of process Lambda function"
  value = aws_lambda_function.process_all.arn
}

output "awswrangler_layer_arn" {
  description = "ARN of AWSWrangler lambda layer"
  value = aws_lambda_layer_version.awswrangler_layer.arn
}

output "common_layer_arn" {
  description = "ARN of common Lambda layer"
  value = aws_lambda_layer_version.common_layer.arn
}

output "s3_access_reporting_function_arn" {
  description = "ARN of s3 access reporting Lambda function"
  value = aws_lambda_function.s3_access_reporting.arn
}

output "backup_param_function_arn" {
  description = "ARN of parameter backup lambda function"
  value = aws_lambda_function.backup_param.arn
}

output "partitions_function_name" {
  description = "Name of Athena partition repair lambda function"
  value = aws_lambda_function.athena.function_name
}

output "partitions_function_arn" {
  description = "ARN of Athena partition repair lambda function"
  value = aws_lambda_function.athena.arn
}

