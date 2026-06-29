resource "aws_cloudtrail" "soc_dashboard_cloudtrail" {
  name           = "${var.project_name}-trail"
  s3_bucket_name = aws_s3_bucket.soc_dashboard_logs.id

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

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

