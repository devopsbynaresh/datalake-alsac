#DMS Replication Instances
resource "aws_dms_replication_instance" "bidbqa-sqlserver-awsdms-cdc-smalltables-instance" {
  replication_instance_class  = "dms.t2.medium"
  replication_instance_id     = "bidbqa-sqlserver-awsdms-cdc-smalltables-instance"
  replication_subnet_group_id = var.dms_replication_subnet_group
  engine_version              = "3.4.1"
  allocated_storage           = 200
  ##multi_az is false for PoC; may want to make true for prod
  multi_az            = false
  availability_zone   = var.dw_availability_zone_1b
  publicly_accessible = false
  auto_minor_version_upgrade = false
  preferred_maintenance_window = "tue:09:55-tue:10:25"
  vpc_security_group_ids = [
    var.dms_security_group
  ]
  tags = {
    "description" = "replication instance for cdc for small tables" 
  }
  
}

#
resource "aws_dms_replication_instance" "bidbqa-sqlserver-awsdms-fullload-largetables-instance" {
  #  provider = aws.dwpoc
  apply_immediately           = true
  replication_instance_class  = "dms.c4.xlarge"
  replication_instance_id     = "bidbqa-sqlserver-awsdms-fullload-largetables-instance"
  replication_subnet_group_id = var.dms_replication_subnet_group
  engine_version              = "3.4.1"
  allocated_storage           = 200
  multi_az                    = false
  publicly_accessible         = false
  availability_zone           = var.dw_availability_zone_1a
  ##preferred_maintenance_window = ddd:hh24:mi-ddd:hh24:mi
  vpc_security_group_ids = [
    var.dms_security_group
  ]
}


#
resource "aws_dms_replication_instance" "bidbqa-sqlserver-awsdms-replication-largetables-instance" {
  auto_minor_version_upgrade  = false
  availability_zone           = var.dw_availability_zone_1a
  replication_instance_class  = "dms.t2.medium"
  replication_instance_id     = "bidbqa-sqlserver-awsdms-replication-largetables-instance"
  replication_subnet_group_id = var.dms_replication_subnet_group
  engine_version              = "3.4.1"
  allocated_storage           = 200
  ##multi_az is false for PoC; may want to make true for prod
  multi_az            = false
  publicly_accessible = false
  preferred_maintenance_window = "mon:06:06-mon:06:36"
  vpc_security_group_ids = [
    var.dms_security_group
  ]
  tags = {
    "description" = "DMS replication instance for larger tables" 
  }
}

resource "aws_dms_replication_instance" "bidbqa-sqlserver-awsdms-fullload-smalltables-instance" {
  apply_immediately           = true
  replication_instance_class  = "dms.c4.xlarge"
  replication_instance_id     = "bidbqa-sqlserver-awsdms-fullload-smalltables-instance"
  replication_subnet_group_id = var.dms_replication_subnet_group
  engine_version              = "3.4.1"
  allocated_storage           = 200
  multi_az                    = false
  publicly_accessible         = false
  availability_zone           = var.dw_availability_zone_1a
  ##preferred_maintenance_window = ddd:hh24:mi-ddd:hh24:mi
  vpc_security_group_ids = [
    var.dms_security_group
  ]
}



##DMS Endpoints
# Create a new endpoint
resource "aws_dms_endpoint" "s3-target-bidbqa" {
  endpoint_id                 = "s3-target-bidbqa"
  endpoint_type               = "target"
  engine_name                 = "s3"
 # extra_connection_attributes ="GZIP;csvDelimiter=|;csvRowDelimiter=\n;dataFormat=csv;datePartitionDelimiter=DASH;datePartitionEnabled=true;timestampColumnName=TIMESTAMP;"
  s3_settings {
    bucket_name             = var.s3_structured_bucket
    compression_type        = "GZIP"
    csv_delimiter           = "|"
    bucket_folder           = var.s3_bidb_bucket_folder
    service_access_role_arn = var.dms_s3_access_role
  }

}

resource "aws_dms_endpoint" "s3-target-fullload-bidbqa" {
  endpoint_id                 = "s3-target-fullload-bidbqa"
  endpoint_type               = "target"
  engine_name                 = "s3"
#  extra_connection_attributes = "compressionType=GZIP;csvDelimiter=|;csvRowDelimiter=\n;dataFormat=csv;datePartitionEnabled=false;includeOpForFullLoad=true;timestampColumnName=TIMESTAMP;"
  s3_settings {
    bucket_name             = var.s3_structured_bucket
    compression_type        = "GZIP"
    csv_delimiter           = "|"
    bucket_folder           = var.s3_bidb_bucket_folder
    service_access_role_arn = var.dms_s3_access_role
  }

}

resource "aws_dms_endpoint" "sqlserver-source-bidbqa" {
  database_name               = "Datastore"
  endpoint_id                 = "sqlserver-source-bidbqa"
  endpoint_type               = "source"
  engine_name                 = "sqlserver"
  extra_connection_attributes = "readBackupOnly=Y;cdcTimeout=3600;ignoreTxnCtxValidityCheck=Y;"
  ##may need to add pw to parameter store into Parameter store
  ## password                    = "test"
  port        = 1433
  server_name = "172.21.0.106\\BIDBQA"
  ssl_mode    = "require"
  username    = "svcAWSDMS"
}

resource "aws_dms_endpoint" "sqlserver-source-bidbqa-log-backup-only" {
  database_name               = "Datastore"
  endpoint_id                 = "sqlserver-source-bidbqa-log-backup-only"
  endpoint_type               = "source"
  engine_name                 = "sqlserver"
  extra_connection_attributes = "readBackupOnly=Y"
  ##may need to add pw to parameter store
  ## password                    = "test"
  port        = 1433
  server_name = "172.21.0.106\\BIDBQA"
  ssl_mode    = "require"
  username    = "svcAWSDMS"
}


##DMS Replication Tasks
# Create a new replication task
resource "aws_dms_replication_task" "bidbqa-largetables-cdc-task" {
  ##  cdc_start_time            = 1484346880
  migration_type            = "cdc"
  replication_instance_arn  = "arn:aws:dms:us-east-1:117183459779:rep:JHULKZC77YRJVNOIMFTYXY5CIARZHASXALYMBBQ"
  replication_task_id       = "bidbqa-largetables-cdc-task"
  replication_task_settings = file("${path.module}/bidbqa-largetables-cdc-task_replication_task_settings.json")
  source_endpoint_arn       = "arn:aws:dms:us-east-1:117183459779:endpoint:CJESOVMGZR5FDPBPU2LV2TTIZGEXVJFJE6VY36Q"
  table_mappings            = file("${path.module}/bidbqa-largetables-cdc-task_table_mappings.json")

  #  tags = {
  #    Name = "test"
  #  }

  target_endpoint_arn = "arn:aws:dms:us-east-1:117183459779:endpoint:EQAEGWGLLW2TNDSALF3RBDRBOQA6TBI67HB4SKQ"
}


# Create a new replication task
resource "aws_dms_replication_task" "bidbqa-smalltables-cdc-task" {
  ##  cdc_start_time            = 1484346880
  migration_type            = "cdc"
  replication_instance_arn  = "arn:aws:dms:us-east-1:117183459779:rep:6DRS4EI57PXVBCAN5FDAYSTMKVMJ7VYSW6BPV5Q"
  replication_task_id       = "bidbqa-smalltables-cdc-task"
  replication_task_settings = file("${path.module}/bidbqa-smalltables-cdc-task_replication_task_settings.json")
  source_endpoint_arn       = "arn:aws:dms:us-east-1:117183459779:endpoint:CJESOVMGZR5FDPBPU2LV2TTIZGEXVJFJE6VY36Q"
  table_mappings            = file("${path.module}/bidbqa-smalltables-cdc-task_table_mappings.json")

  #  tags = {
  #    Name = "test"
  #  }

  target_endpoint_arn = "arn:aws:dms:us-east-1:117183459779:endpoint:EQAEGWGLLW2TNDSALF3RBDRBOQA6TBI67HB4SKQ"
}



## DMS Full Load Replication Tasks ##
resource "aws_dms_replication_task" "bidbqa-sqlserver-awsdms-fullload-largetables-task" {
  ##  cdc_start_time            = 1484346880
  migration_type            = "full-load"
  replication_instance_arn  = "arn:aws:dms:us-east-1:117183459779:rep:JHULKZC77YRJVNOIMFTYXY5CIARZHASXALYMBBQ"
  replication_task_id       = "bidbqa-sqlserver-awsdms-fullload-largetables-task"
  replication_task_settings = file("${path.module}/bidbqa-largetables-fullload-task_replication_task_settings.json")
  source_endpoint_arn       = "arn:aws:dms:us-east-1:117183459779:endpoint:CJESOVMGZR5FDPBPU2LV2TTIZGEXVJFJE6VY36Q"
  table_mappings            = file("${path.module}/bidbqa-largetables-fullload-task_table_mappings.json")

  #  tags = {
  #    Name = "test"
  #  }

  target_endpoint_arn = "arn:aws:dms:us-east-1:117183459779:endpoint:FYXDDVXWKWKZB6G4ZXQBETQY3P33GKCWOWD277Y"
}


resource "aws_dms_replication_task" "bidbqa-sqlserver-awsdms-fullload-smalltables-task" {
  ##  cdc_start_time            = 1484346880
  migration_type            = "full-load"
  replication_instance_arn  = "arn:aws:dms:us-east-1:117183459779:rep:JHULKZC77YRJVNOIMFTYXY5CIARZHASXALYMBBQ"
  replication_task_id       = "bidbqa-sqlserver-awsdms-fullload-smalltables-task"
  replication_task_settings = file("${path.module}/bidbqa-smalltables-fullload-task_replication_task_settings.json")
  source_endpoint_arn       = "arn:aws:dms:us-east-1:117183459779:endpoint:CJESOVMGZR5FDPBPU2LV2TTIZGEXVJFJE6VY36Q"
  table_mappings            = file("${path.module}/bidbqa-smalltables-fullload-task_table_mappings.json")

  #  tags = {
  #    Name = "test"
  #  }

  target_endpoint_arn = "arn:aws:dms:us-east-1:117183459779:endpoint:FYXDDVXWKWKZB6G4ZXQBETQY3P33GKCWOWD277Y"
}



#DMS Event Subscriptions
resource "aws_dms_event_subscription" "dms-migration-task-failure-event-subscription" {
  enabled          = true
  event_categories = ["failure"]
  name             = "dms-migration-task-failure-event-subscription"
  sns_topic_arn    = "arn:aws:sns:us-east-1:117183459779:dms-migration-task-failure-event-subscription"
  source_type      = "replication-task"
}