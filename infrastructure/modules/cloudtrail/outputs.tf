output "cloudtrail_arn" {
    description = "The ARN of the CloudTrail trail"
    value = aws_cloudtrail.s3_object_logs_trail.arn
}