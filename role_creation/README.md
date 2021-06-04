# Role Creation Overview

This creates the appropriate IAM roles for Data Lake team members to assume and service roles. The purpose of these roles is to scope down the permissions for members, so that they only have access to the AWS services they need.

These roles are for data analysts, developers/data lake admins, infrastructure admins, and specific AWS services that need to integrate with other AWS services.

**Analyst Role:** This can be assumed by a data analyst. They will only be able to run queries in Athena and view results in the AWS console. Because the analyst will run Athena queries in the AWS console, they will also need limited read-only access to the Glue databases. The analyst also has limited access to S3 buckets, where they have read-only for all the data lake buckets and can only upload files to the GAdsDISC folder in the Raw bucket.

**Developer Role:** This can be assumed by a developer or data lake admin. They will have access to the core data lake services, such as Lambda and Glue. They have read-only permissions to Glue, S3, IAM, KMS (for the Lambda functions), SSM Parameter Store, Athena, CloudWatch, and SNS. They also have a write access to specific AWS services that are relevant to the Data Lake, and this is implemented using attributed-based access control (ABAC) through tagging.

**Infrastructure Role:** This can be assumed by an infrastructure admin, who is responsible for deploying the Terraform scripts in [infrastructure](../infrastructure) and maintaining AWS services that support the data lake. They have read and write permissions to only the specific AWS services needed.

**Lambda Role:** This can be assumed by the Lambda service, specifically the Lambda functions created in [infrastructure](../infrastructure/). Only the role is defined here; the policy is defined in the [Lambda module](../infrastructure/modules/lambda/main.tf).

## Initial Setup

> You should already have admin privileges for IAM in AWS.

##### 1. Install [Terraform v0.12.24](https://www.terraform.io/downloads.html) if not already installed.

To check the version:

```bash
$ terraform --version
```

If using Linux or MacOS, you can use `tfenv`:

```bash
$ git clone https://github.com/tfutils/tfenv.git
$ cd tfenv
$ tfenv install 0.12.24
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

##### 3. Create dedicated S3 bucket and DynamoDB table for backend

For the [Terraform backend](https://www.terraform.io/docs/backends/types/s3.html), a dedicated S3 bucket and DynamoDB table must already exist to configure the backend and state locking. Establishing a remote backend centralizes the configuration and prevents any corruption from multiple developers running Terraform locally.

The DynamoDB table must have **LockID** as the partition key.

##### 4. Modify any necessary inputs before deploying with Terraform (see below)

## Inputs

Before running the scripts, you may modify the following inputs in `main.tf`.

#### Provider

`provider "aws" {...}`

| Input   | Description                                               | Default |
| ------- | --------------------------------------------------------- | ------- |
| profile | AWS profile (~/.aws/config) to use when running Terraform | alsac   |

#### Terraform Backend

`terraform { backend "s3" {...} }`

| Input          | Description                                                         | Default                                  |
| -------------- | ------------------------------------------------------------------- | ---------------------------------------- |
| profile        | AWS profile (~/.aws/config) to use when running Terraform           | alsac                                    |
| bucket         | S3 bucket containing the role_creation .tfstate file                | alsac-tfstate-development                |
| key            | Folder and file name within the S3 bucket to hold the .tfstate file | data-lake-development/infra-role.tfstate |
| dynamodb_table | DynamoDB table to lock the .tfstate file                            | alsac-tfstate-lock-development           |

<!-- #### Infrastructure Role

`resource "aws_iam_role" "role" {...}`

| Input     | Description                                                 | Default              |
| --------- | ----------------------------------------------------------- | -------------------- |
| name      | Name of IAM role                                            | sl_infra_team_role   |
| Principal | List of federated IAM users to trust when assuming the role | List of Slalom users |

#### Developer Role

`resource "aws_iam_role" "data_role" {...}`

| Input     | Description                                                 | Default              |
| --------- | ----------------------------------------------------------- | -------------------- |
| name      | Name of IAM role                                            | sl_data_team_role    |
| Principal | List of federated IAM users to trust when assuming the role | List of Slalom users |

#### Analyst Role

`resource "aws_iam_role" "analyst_role" {...}`

| Input     | Description                                                 | Default              |
| --------- | ----------------------------------------------------------- | -------------------- |
| name      | Name of IAM role                                            | sl_analyst_role      |
| Principal | List of federated IAM users to trust when assuming the role | List of Slalom users | -->

#### Lambda Role

`resource "aws_iam_role" "lambda_role" {...}`

| Input | Description      | Default        |
| ----- | ---------------- | -------------- |
| name  | Name of IAM role | sl_lambda_role |

#### Glue Role

`resource "aws_iam_role" "glue_role" {...}`

| Input | Description      | Default      |
| ----- | ---------------- | ------------ |
| name  | Name of IAM role | sl_glue_role |

## How to Run

1. Clone this repo:

```bash
$ git clone ssh://git@bitbucket.alsac.stjude.org:7999/itse/slalom.git
```

2. Navigate to the `role_creation` folder.
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
