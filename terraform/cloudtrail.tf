# The trail is the source of truth for the whole pipeline: it records every
# API call across the account and delivers copies to both S3 (durable audit
# log) and CloudWatch Logs (feeds EventBridge for near-real-time alerting).
resource "aws_cloudtrail" "soc_dashboard_cloudtrail" {
  name           = "${var.project_name}-trail"
  s3_bucket_name = aws_s3_bucket.soc_dashboard_logs.id

  # Multi-region + global service events so IAM changes (a global service)
  # and activity in any region are captured, not just the provider's default region.
  include_global_service_events = true
  is_multi_region_trail         = true
  # Detects tampering with delivered log files.
  enable_log_file_validation = true

  # Streams events into CloudWatch Logs so EventBridge can pattern-match on
  # them in near-real time (S3 delivery alone is batched and too slow for alerting).
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn

  # Log all management events (both read and write) since this is a
  # security-monitoring trail, not a data-plane audit trail.
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  # Explicit ordering: the bucket policy and log-group IAM wiring must exist
  # before CloudTrail attempts its first delivery, or it fails to enable.
  depends_on = [
    aws_s3_bucket.soc_dashboard_logs,
    aws_s3_bucket_policy.cloudtrail_logs,
    aws_cloudwatch_log_group.cloudtrail_logs,
    aws_iam_role_policy_attachment.cloudtrail_cloudwatch_policy,
  ]

  tags = {
    name = "aws-soc-dashboard-cloudtrail"
  }
}

