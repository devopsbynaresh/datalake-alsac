# Create Glue catalog database for ingested data sources
resource "aws_glue_catalog_database" "database" {
  name = var.data_catalog_database_name
}

# Create Glue table for Facebook Ads
resource "aws_glue_catalog_table" "fbad_table" {
  name = var.fbad_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.fbad_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "fbad-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "adset_name"
      type = "string"
    }

    columns {
      name = "campaign_name"
      type = "string"
    }

    columns {
      name = "spend"
      type = "double"
    }

    columns {
      name = "impressions"
      type = "bigint"
    }

    columns {
      name = "clicks"
      type = "bigint"
    }

    columns {
      name = "inline_link_clicks"
      type = "bigint"
    }

    columns {
      name = "device_platform"
      type = "string"
    }

    columns {
      name = "publisher_platform"
      type = "string"
    }
  }
}

# Create Glue table for GCM standard reports
resource "aws_glue_catalog_table" "gcm_table" {
  name          = var.gcm_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
    "EXTERNAL" = "TRUE"

  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.gcm_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "gcm-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "advertiser"
      type = "string"
    }

    columns {
      name = "site (dcm)"
      type = "string"
    }

    columns {
      name    = "campaign"
      type    = "string"
    }

    columns {
      name    = "placement"
      type    = "string"
    }

    columns {
      name    = "placement id"
      type    = "bigint"
    }

    columns {
      name = "platform type"
      type = "string"
    }

    columns {
      name = "activity" 
      type = "string"
    }

    columns {
      name = "activity group" 
      type = "string"
    }

    columns {
      name = "impressions" 
      type = "bigint"
    }

    columns {
      name = "clicks"
      type = "bigint"
    }

    columns {
      name = "click rate"
      type = "double"
    }

    columns {
      name = "total conversions"
      type = "bigint"
    }

    columns {
      name = "video completions"
      type = "bigint"
    }

    columns {
      name = "view-through conversions"
      type = "bigint"
    }

    columns {
      name = "click-through conversions"
      type = "bigint"
    }

    columns {
      name = "video first quartile completions"
      type = "bigint"
    }

    columns {
      name = "video midpoints"
      type = "bigint"
    }

    columns {
      name = "video plays"
      type = "bigint"
    }

    columns {
      name = "click-through revenue"
      type = "double"
    }

    columns {
      name = "view-through revenue"
      type = "double"
    }

    columns {
      name = "total revenue"
      type = "double"
    }

    columns {
      name = "click-through conversions + cross-environment"
      type = "bigint"
    }

    columns {
      name = "click-through revenue + cross-environment"
      type = "double"
    }

    columns {
      name = "total conversions + cross-environment" 
      type = "bigint"
    }

    columns {
      name = "total revenue + cross-environment"
      type = "double"
    }

    columns {
      name = "view-through conversions + cross-environment" 
      type = "bigint"
    }

    columns {
      name = "view-through revenue + cross-environment"
      type = "double"
    }

    columns {
      name = "dbm cost (account currency)"
      type = "double"
    }
    columns {
      name = "media cost"
      type = "double"
    }
  }
}


# Create Glue table for GCM standard sa360 cost response reports
resource "aws_glue_catalog_table" "gcm_sa360_cost_response_table" {
  name          = var.gcm_sa360_cost_response_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
    "EXTERNAL" = "TRUE"

  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.gcm_sa360_cost_response_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "gcm-sa360-cost-response-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "paid search campaign"
      type = "string"
    }

    columns {
      name = "paid search ad group"
      type = "string"
    }

    columns {
      name    = "paid search ad group id"
      type    = "bigint"
    }

    columns {
      name    = "site (dcm)"
      type    = "string"
    }

    columns {
      name    = "paid search cost"
      type    = "double"
    }

    columns {
      name = "paid search impressions"
      type = "bigint"
    }

    columns {
      name = "paid search clicks" 
      type = "bigint"
    }

  }
}


# Create Glue table for GCM standard sa360 transactions reports
resource "aws_glue_catalog_table" "gcm_sa360_transactions_table" {
  name          = var.gcm_sa360_transactions_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
    "EXTERNAL" = "TRUE"

  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.gcm_sa360_transactions_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "gcm-sa360-transactions-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "paid search campaign"
      type = "string"
    }

    columns {
      name = "paid search ad group"
      type = "string"
    }

    columns {
      name    = "paid search ad group id"
      type    = "bigint"
    }

    columns {
      name    = "site (dcm)"
      type    = "string"
    }

    columns {
      name    = "donation complete : donation complete - monthly: paid search revenue"
      type    = "double"
    }

    columns {
    name    = "donation complete : donation complete - monthly: paid search transactions"
    type    = "bigint"
    }

    columns {
    name    = "donation complete : donation complete - one time: paid search revenue"
    type    = "double"
    }

    columns {
    name    = "donation complete : donation complete - one time: paid search transactions"
    type    = "bigint"
    }
  }
}

# Create Glue table for GCM floodlight reports
resource "aws_glue_catalog_table" "gcm_floodlight_table" {
  name          = var.gcm_floodlight_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.gcm_floodlight_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "gcm-floodlight-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "activity"
      type = "string"
    }

    columns {
      name = "activity id"
      type = "bigint"
    }

    columns {
      name = "activity date/time"
      type = "string"
    }

    columns {
      name = "campaign"
      type = "string"
    }

    columns {
      name = "campaign id"
      type = "bigint"
    }

    columns {
      name = "site (dcm)"
      type = "string"
    }

    columns {
      name = "placement"
      type = "string"
    }

    columns {
      name = "creative"
      type = "string"
    }

    columns {
      name = "ord value"
      type = "string"
    }

    columns {
      name = "placement id"
      type = "bigint"
    }

    columns {
      name = "site id (dcm)"
      type = "bigint"
    }

    columns {
      name = "floodlight attribution type"
      type = "string"
    }

    columns {
      name = "interaction channel"
      type = "string"
    }

    columns {
      name = "interaction type"
      type = "string"
    }

    columns {
      name = "path type"
      type = "string"
    }

    columns {
      name = "audience targeted"
      type = "string"
    }

    columns {
      name = "browser/platform"
      type = "string"
    }

    columns {
      name = "operating system"
      type = "string"
    }

    columns {
      name = "platform type"
      type = "string"
    }

    columns {
      name = "ad id"
      type = "bigint"
    }

    columns {
      name = "ad"
      type = "string"
    }

    columns {
      name = "ad type"
      type = "string"
    }

    columns {
      name = "advertiser"
      type = "string"
    }

    columns {
      name = "advertiser group"
      type = "string"
    }

    columns {
      name = "creative id"
      type = "bigint"
    }

    columns {
      name = "creative type"
      type = "string"
    }

    columns {
      name = "creative pixel size"
      type = "string"
    }

    columns {
      name = "city"
      type = "string"
    }

    columns {
      name = "country"
      type = "string"
    }

    columns {
      name = "designated market area (dma)"
      type = "string"
    }

    columns {
      name = "state/region"
      type = "string"
    }

    columns {
      name = "zip/postal code"
      type = "string"
    }

    columns {
      name = "click count"
      type = "bigint"
    }

    columns {
      name = "impression count"
      type = "bigint"
    }

    columns {
      name = "path length"
      type = "bigint"
    }

    columns {
      name = "days since attribution interaction"
      type = "string"
    }

    columns {
      name = "days since first interaction"
      type = "string"
    }

    columns {
      name = "hours since attributed interaction"
      type = "string"
    }

    columns {
      name = "hours since first interaction"
      type = "string"
    }

    columns {
      name = "click-through conversions"
      type = "int"
    }

    columns {
      name = "view-through conversions"
      type = "int"
    }

    columns {
      name = "total conversions"
      type = "bigint"
    }

    columns {
      name = "total revenue"
      type = "double"
    }

    columns {
      name = "click-through revenue"
      type = "double"
    }

    columns {
      name = "view-through revenue"
      type = "double"
    }

    columns {
      name = "video first quartile completions"
      type = "bigint"
    }

    columns {
      name = "video midpoints"
      type = "bigint"
    }

    columns {
      name = "video third quartile"
      type = "bigint"
    }

    columns {
      name = "video completions"
      type = "bigint"
    }

        columns {
      name = "paid search ad group"
      type = "string"
    }

        columns {
      name = "paid search ad group id"
      type = "bigint"
    }

        columns {
      name = "paid search campaign"
      type = "string"
    }
  }
}

# Create Glue table for GAds reports
resource "aws_glue_catalog_table" "gads_table" {
  name          = var.gads_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.gads_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "gads-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "campaign"
      type = "string"
    }

    columns {
      name = "ad_group"
      type = "string"
    }

    columns {
      name    = "device"
      type    = "string"
    }

    columns {
      name    = "cost_micros"
      type    = "double"
    }
  }
}

# Create Glue table for GAds Discovery reports
resource "aws_glue_catalog_table" "gadsdisc_table" {
  name          = var.gadsdisc_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.gadsdisc_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "gadsdisc-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "campaign"
      type = "string"
    }

    columns {
      name = "ad_group"
      type = "string"
    }

    columns {
      name    = "device"
      type    = "string"
    }

	 columns {
      name    = "cost"
      type    = "double"
    }

    columns {
      name    = "impressions"
      type    = "bigint"
    }
  }
}

# Create Glue table for GAds PaidSearch reports
resource "aws_glue_catalog_table" "gadsps_table" {
  name          = var.gadsps_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.gadsps_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "gadsps-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "campaign"
      type = "string"
    }

    columns {
      name = "ad_group"
      type = "string"
    }

    columns {
      name    = "device"
      type    = "string"
    }

    columns {
      name    = "cost_micros"
      type    = "double"
    }

    columns {
      name = "impressions"
      type = "bigint"
    }
  }
}

# Create Glue table for Adobe Ad Cloud
resource "aws_glue_catalog_table" "adobe_ad_cloud_table" {
  name = var.aac_table_name
  database_name = aws_glue_catalog_database.database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "parquet.compression" = "SNAPPY"
    "classification" = "parquet"
  }

  partition_keys {
      name = "date"
      type = "string"
  }

  storage_descriptor {
    location      = var.adobe_ad_cloud_table_location
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "aac-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "campaign name"
      type = "string"
    }

    columns {
      name = "placement name"
      type = "string"
    }

    columns {
      name = "ad name"
      type = "string"
    }

    columns {
      name = "hardware"
      type = "string"
    }

    columns {
      name = "total net spend"
      type = "double"
    }
  }
}
