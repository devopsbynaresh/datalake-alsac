# Overview of Scripts for Data Warehouse Proof of Concept

This repository contains scripts created by Slalom to automate the data pipeline and the deployment of the AWS infrastructure supporting the DW PoC. The Infrastructure-as-Code tool selected is Terraform.

## Description of Terraform Components

|Terraform Configuration Name|Description
|--|--|
| [awsdms.tf](./awsdms.tf)|Creates AWS Database Migration Service (DMS) Replication Instances, DMS Endpoints, and DMS replication tasks.|
|[bidbqa-largetables-cdc-task_replication_task_settings.json](./bidbqa-largetables-cdc-task_replication_task_settings.json)| Contains task settings for DMS large tables’ continuous replication task (bidbqa-largetables-cdc-task) in [awsdms.tf](./awsdms.tf).|
| [bidbqa-largetables-cdc-task_table_mappings.json](./bidbqa-largetables-cdc-task_table_mappings.json)| Contains table mappings for DMS large continuous replication task (bidbqa-largetables-cdc-task) in [awsdms.tf](./awsdms.tf).|
|[bidbqa-smalltables-cdc-task_replication_task_settings.json](./bidbqa-smalltables-cdc-task_replication_task_settings.json)| Contains task settings for DMS small tables’ continuous replication task (bidbqa-smalltables-cdc-task) in [awsdms.tf](./awsdms.tf).|
|[bidbqa-smalltables-cdc-task_table_mappings.json](./bidbqa-smalltables-cdc-task_table_mappings.json)|  Contains table mappings for DMS small tables’ continuous replication task (bidbqa-smalltables-cdc-task) in [awsdms.tf](./awsdms.tf).|
|[bidbqa-largetables-fullload-task_replication_task_settings.json](./bidbqa-largetables-fullload-task_replication_task_settings.json)| Contains task settings for DMS large tables’ full load task (bidbqa-sqlserver-awsdms-fullload-largetables-task) in [awsdms.tf](./awsdms.tf).|
|[bidbqa-largetables-fullload-task_table_mappings.json](./bidbqa-largetables-fullload-task_table_mappings.json)|  Contains table mappings for DMS large tables’ full load task (bidbqa-sqlserver-awsdms-fullload-largetables-task) in [awsdms.tf](./awsdms.tf).|
|[bidbqa-smalltables-fullload-task_replication_task_settings.json](./bidbqa-smalltables-fullload-task_replication_task_settings.json)| Contains task settings for DMS small tables’ full load task (bidbqa-sqlserver-awsdms-fullload-smalltables-task) in [awsdms.tf](./awsdms.tf).|
|[bidbqa-smalltables-fullload-task_table_mappings.json](./bidbqa-smalltables-fullload-task_table_mappings.json)|  Contains table mappings for DMS large tables’ full load task (bidbqa-sqlserver-awsdms-fullload-smalltables-task) in [awsdms.tf](./awsdms.tf).|
|[dev.tfvars](./dev.tfvars)|Declares environment variables for development deployment.|
|[glue.tf](./glue.tf)|Creates AWS Glue jobs and connections.|
|[main.tf](./main.tf)| Defines provider information, Terraform backend information, and variables used in multiple Terraform configuration files.|
|redshift|Creates Redshift cluster. Please see [Runbook-Terraform-DW PoC.docx](https://alsacwiki.stjude.org/pages/viewpage.action?pageId=181125729&preview=/181125729/190426720/Runbook-Terraform-DW%20PoC.docx) for additional information.|
|[step-function-state-machine.tf](./step-function-state-machine.tf)|Creates Step Function State Machine.|
|[variables.tf](./variables.tf)|Defines environment variables that can be used to deploy between different AWS environments.|
|[cloudwatch.tf](./cloudwatch.tf)|Creates CloudWatch events and metric alarms for multiple sources.|
|[subnets.tf](./subnets.tf)|Creates subnets for Redshift and DMS.|
|[subnet_groups.tf](./subnet_groups.tf)|Creates subnet groups for Redshift and DMS.|
|[security_groups.tf](./security_groups.tf)|Creates security groups for Redshift and DMS.|


## Description of IAM Roles related to DW Proof Of Concept

The following are a list of the IAM roles used in the Data Warehouse Proof of Concept Terraform build. Variables for these roles are in [main.tf](./main.tf).

|IAM Role Name|Description|
|--|--|
|glue-s3-redshift-access-role|Allows Glue to call S3 & Redshift.|
|dms_s3_access_role|Allows Database Migration Service to access S3.|
|step-run-glue-jobs|Role to allow step functions to run Glue jobs.|
