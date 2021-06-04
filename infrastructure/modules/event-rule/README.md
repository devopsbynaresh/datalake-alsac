# CloudWatch Event Rule

## Data Pipeline

This creates a CloudWatch Event rule that runs hourly to trigger the Monitoring Lambda function.

Another CloudWatch Event rule was created to run daily to trigger the Download Lambda function.

The schedule expression for the rule can either be in `cron` or `rate` syntax.

# S3 Access Reporting

Creates a CloudWatch Event rule that triggers the S3 access reporting Lambda at midnight UTC every Tuesday.

The schedule expression for the rule is in `cron` syntax.

## Reporting and Backup

Creates a CloudWatch Event rule that runs daily to trigger the Parameter Backup Lambda function.

The schedule expression for the rule can either be in `cron` or `rate` syntax.
