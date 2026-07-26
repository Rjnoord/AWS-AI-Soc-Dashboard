# Log group CloudTrail streams events into; this is what EventBridge
# actually watches (S3 delivery is too batched for real-time alerting).
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name = "/aws/cloudtrail/${var.project_name}"
  # Lab-appropriate retention; keeps costs down since S3 already holds the
  # durable long-term copy of these logs.
  retention_in_days = 30

  tags = {
    name = "cloudtrail-log-group"
  }
}
