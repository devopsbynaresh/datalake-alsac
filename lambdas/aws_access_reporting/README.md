# AWS Access Reporting Lambda Function

## Overview

Enclosed is a Python 3 module and associated tests for generating AWS access reports from CloudTrail data.

The module takes an S3 bucket name as input and, with the right permissions in place, uses Athena to process CloudTrail data and create AWS access reports for new and historical log data.

It is meant to be invoked as an AWS Lambda function triggered by a CloudWatch event.
The handler(event, context) function is the module entrypoint.

Currently, the Lambda function is set up inside the ALSAC Security AWS account to automatically trigger every Tuesday at midnight UTC.

## Example Query

One nice thing about this module is that it leverages Athena to perform data processing. So, if you want to run ad hoc queries against the data set, you can with a SQL-like syntax. An example Athena query that was generated by the module is below:

```sql
SELECT useridentity.principalId AS Requester,
         sourceipaddress AS SourceIP,
         count(*) AS NumRequests
FROM aws_access_reporting.aws_access_reporting_117183459779
WHERE region IN ('us-east-1')
        AND ((year = '2020'
        AND month = '06'
        AND day = '27')
        OR (year = '2020'
        AND month = '06'
        AND day = '26')
        OR (year = '2020'
        AND month = '06'
        AND day = '25')
        OR (year = '2020'
        AND month = '06'
        AND day = '24')
        OR (year = '2020'
        AND month = '06'
        AND day = '23')
        OR (year = '2020'
        AND month = '06'
        AND day = '22')
        OR (year = '2020'
        AND month = '06'
        AND day = '21'))
GROUP BY  useridentity.principalId, sourceipaddress
ORDER BY  useridentity.principalId
```

You can copy and paste that into Athena, tweak it as needed, and submit to get real live results.

## Terraform

The Terraform used to deploy the Lambda function into the ALSAC Security AWS account is also enclosed.
To run that Terraform, simply run `terraform init` and `terraform apply`.
