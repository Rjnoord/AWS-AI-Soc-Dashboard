resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/cloudtrail/${var.project_name}"
  retention_in_days = 30

  tags = {
    name = "cloudtrail-log-group"
  }
}
