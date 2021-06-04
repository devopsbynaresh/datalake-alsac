# SNS Topics

Creates three SNS topics.

- **Lambda topic**: Coordinates the Monitor Lambda with the Download Lambda. When the Monitor Lambda detects new data, it will publish to the Lambda topic, which will trigger the Download Lambda.
- **Data Lake Team alarm topic**: CloudWatch will publish to this topic if alarms are raised for the following:
  - Lambda function errors
  - Lambda function long durations
  - CloudWatch Event failed invocations
  - S3 system errors
  - S3 client errors
  - SNS failed notifications
  - Billing estimated charges
- **Infrastructrue Team alarm topic**: CloudWatch will publish to this topic if alarms are raised for the following:
  - DynamoDB system errors
  - DynamoDB client errors
  - Billing estimated charges

Subscriptions must be manually created for the Alarm topic, since none are created by default.

IAM policy documents were also created to grant CloudWatch Events and Lambda permission to publish to SNS topics.
