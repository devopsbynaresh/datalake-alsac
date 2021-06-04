# Data Pipeline Assets

This set of scripts are used to stand up the infrastructure needed for the ALSAC data lake. **These scripts should only be run if the roles created in [role_creation](../role_creation) and the buckets created in [zone_buckets](../zone_buckets) already exist.**

## Why Terraform?

The [Terraform](https://www.terraform.io/) scripts are meant to be re-usable, so that the infrastructure can be easily re-deployed in different environments.

## What It Does

These scripts provision components from the following AWS services: AWS Glue, Lambda, CloudWatch, SNS, and CloudTrail. All service components are grouped by module, which are in folders:

```bash
├───modules
│   ├───cloudtrail
│   ├───event-rule
│   ├───glue
│   ├───lambda
│   ├───metric-alarm
│   ├───monitoring
│   └───sns
│
├───README.md
└───INPUTS.md
```

The modules perform the following functions:

- `modules/cloudtrail`: creates a [CloudTrail trail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html) for S3 access logging.
- `modules/event-rule`: creates a [CloudWatch Event Rule](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html) that runs on an hourly schedule to trigger the monitoring Lambda function.
- `modules/glue`: creates [Glue databases](https://docs.aws.amazon.com/glue/latest/dg/define-database.html) and tables to extract the data stored in the S3 buckets so that they can be queried by [Athena](https://aws.amazon.com/athena/).
- `modules/lambda`: for the data pipeline, deploys 5 [Lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html): GCM Monitor, Download, Process, GCM Extract, and Athena Partition Loading. For reporting and backup, deploys three Lambda functions: S3 Access Reporting, AWS Account Access Reporting, and Parameter Backup.
- `modules/metric-alarm`: creates [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) for the Lambda functions. If a Lambda function encounters an error while running, the alarm will send out notifications.
- `modules/monitoring`: creates a CloudWatch monitoring dashboard.
- `modules/sns`: creates three [SNS topics](https://docs.aws.amazon.com/sns/latest/dg/sns-tutorial-create-topic.html): one for coordinating Lambda functions, and two for CloudWatch alarms linked to Lambda and infrastructure errors.

## Manual Components

Some of the items in the infrastructure diagram are not included in Terraform. The following components must be manually accessed or provisioned in AWS:

- **Athena**
  - A data analyst will go into the console and run Athena queries against the data stored in the Glue databases.
- **Systems Manager Parameter Store**
  - Data source service account credentials and report metadata must be uploaded to the [Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html).
  - These parameters will be used by the Lambda functions.
- **SNS Subscriptions**
  - To get e-mail or SMS notifications on any Lambda errors, you will need to create [subscriptions](https://docs.aws.amazon.com/sns/latest/dg/sns-tutorial-create-subscribe-endpoint-to-topic.html) for the CloudWatch Alarm SNS topic.

## Initial Setup

##### 1. Install [Terraform](https://www.terraform.io/downloads.html) if not already installed.

To check the version:

```bash
$ terraform --version
```

If using Linux or MacOS, you can use `tfenv`:

```bash
$ git clone https://github.com/tfutils/tfenv.git
$ cd tfenv
$ tfenv install 0.12.29
```

##### 2. Set up your AWS profile for the [AWS provider](https://www.terraform.io/docs/providers/aws/index.html).

Because Active Directory federation is already set up with your AWS account, you can use [saml2aws](https://github.com/Versent/saml2aws#install). If saml2aws is not configured yet, run the following:

```bash
$ saml2aws configure
$ ? Please choose a provider: Okta
$ ? Please choose an MFA: OKTA
$ ? AWS Profile (saml)
$ ? URL https://alsac.okta.com/home/amazon_aws/0oa1xx7rowXQhZ0nv297/272
$ ? Username <your AD username>
$ ? Password <your AD password>
$ ? Confirm <your AD password>
```

Otherwise, run:

```bash
$ saml2aws login
```

This will populate `~/.aws/credentials` with a temporary AWS access key id, secret access key, and session token.

##### 3. Assume role with enough permissions to deploy Terraform

If you are already authenticated to AWS as an administrator, you can skip to the next step.

Otherwise, if you do not have administrative access to S3, Lambda, CloudWatch, SNS, DynamoDB, IAM, CloudWatch EventBridge, and AWS Glue, you will need to assume the infrastructure admin role that was created in `../role_creation`. Your administrator would need to add a trust relationship between the role and your AWS user.

Open `~/.aws/config` and include the following:

```
[profile alsac]
region = us-east-1
role_arn = arn:aws:iam::117183459779:role/sl_infra_team_role
source_profile = saml
```

##### 4. Modify any necessary inputs before deploying with Terraform (see [Input Details](INPUTS.md))

## How to Run

1. Clone this repo:

```bash
$ git clone ssh://git@bitbucket.alsac.stjude.org:7999/itse/slalom.git
```

2. Navigate to the `infrastructure` folder.
3. Initialize the Terraform stack, create an execution plan, and verify that there are no unintended/unwanted changes or errors.

```bash
$ terraform init -backend-config <ENV>.tfvars
$ terraform plan -var-file <ENV>.tfvars
```

4. Apply the changes.

```bash
$ terraform apply -var-file <ENV>.tfvars
```

## Clean-up

If you need to tear down a Terraform stack, run the destroy command in the working directory.

```bash
$ terraform destroy -var-file <ENV>.tfvars
```
