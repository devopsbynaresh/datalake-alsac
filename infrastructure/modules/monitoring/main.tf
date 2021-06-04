data "local_file" "dashboard_configuration" {
  filename = "${path.module}/dashboard-config.json"
}

resource "aws_cloudwatch_dashboard" "datalake_monitoring_dashboard" {
  dashboard_name = var.dashboard_name
  dashboard_body = data.local_file.dashboard_configuration.content
}
