# Final stage of the pipeline: fans out the Lambda's risk-scored, AI-
# summarized incident to a human via email/SMS.

# Topic the incident-report Lambda publishes to; subscriptions below control
# who actually receives the alert.
resource "aws_sns_topic" "security_alerts" {
  name = "${var.project_name}-security-alerts"

  tags = {
    Name        = "${var.project_name}-security-alerts"
    Environment = var.environment
    Owner       = var.owner
  }
}

# Optional email subscription; only created if alert_email is set, so the
# lab can be deployed without requiring a confirmed subscriber.
resource "aws_sns_topic_subscription" "sns_alerts" {
  count = var.alert_email != null && var.alert_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Optional SMS subscription for faster (out-of-band) notification of
# high-severity incidents; also conditionally created.
resource "aws_sns_topic_subscription" "sms" {
  count = var.alert_phone_number != null && var.alert_phone_number != "" ? 1 : 0

  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "sms"
  endpoint  = var.alert_phone_number
}
