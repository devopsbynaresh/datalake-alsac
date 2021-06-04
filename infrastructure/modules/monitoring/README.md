# Monitoring

Creates a monitoring dashboard for the data lake.

The dashboard contains the following metrics:

- Amazon Simple Storage Service (S3)
  - PutRequests – to see if abnormal amounts of data are being ingested
  - DeleteRequests – to see if data is being deleted unexpectedly
  - 4xxErrors – to see how many client errors are occurring over time
  - 5xxErrors – to see how many server errors are occurring over time
- AWS Lambda
  - Duration – to see if functions are running longer or shorter than usual
  - Errors – to see if lambdas are failing
  - Invocations – to see if an abnormal number of invocations are occurring
- Amazon Athena
  - TotalExecutionTime – to see if queries are running longer or shorter than
    usual
- Amazon Simple Notification Service (SNS)
  - NumberOfNotificationsFailed – to see if notifications are failing
- Amazon CloudWatch Events
  - Invocations – to see if an abnormal number of invocations are occurring
  - FailedInvocations – to see if invocations are failing
- Amazon DynamoDB
  - SystemErrors – to see how many server errors are occurring over time
  - UserErrors – to see how many client errors are occurring over time
- Billing
  - EstimatedCharges – to see if estimated charges are higher than expected
