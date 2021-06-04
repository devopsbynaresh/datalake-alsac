output "database" {
  description = "Name of Glue database"
  value = aws_glue_catalog_database.database.name
}

output "fbad_table" {
  description = "Name of Glue table for Facebook Ads"
  value = aws_glue_catalog_table.fbad_table.name
}

output "gcm_table" {
  description = "Name of Glue table for GCM standard"
  value = aws_glue_catalog_table.gcm_table.name
}

output "gcm_sa360_cost_response_table" {
  description = "Name of the Glue table for GCM standard SA360 Cost response data"
  value = aws_glue_catalog_table.gcm_sa360_cost_response_table.name
}

output "gcm_sa360_transactions_table" {
  description = "Name of the Glue table for GCM standard SA360 transactions data"
  value = aws_glue_catalog_table.gcm_sa360_transactions_table.name
}

output "gads_table" {
  description = "Name of Glue table for Google Ads Display"
  value = aws_glue_catalog_table.gads_table.name
}

output "gadsdisc_table" {
  description = "Name of Glue table for Google Ads Discovery"
  value = aws_glue_catalog_table.gadsdisc_table.name
}

output "gadsps_table" {
  description = "Name of Glue table for Google Ads PaidSearch"
  value = aws_glue_catalog_table.gadsps_table.name
}

output "gcm_floodlight_table" {
  description = "Name of Glue table for GCM Floodlight"
  value = aws_glue_catalog_table.gcm_floodlight_table.name
}

output "adobe_ad_cloud_table" {
  description = "Name of Glue table for Adobe AdCloud"
  value = aws_glue_catalog_table.adobe_ad_cloud_table.name
}
