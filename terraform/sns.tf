resource "aws_sns_topic" "security_alerts" {
  name = "${var.project_name}-security-alerts"

  tags = {
    Name        = "${var.project_name}-security-alerts"
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_sns_topic_subscription" "sns_alerts" {
  count = var.alert_email != null && var.alert_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_sns_topic_subscription" "sms" {
  count = var.alert_phone_number != null && var.alert_phone_number != "" ? 1 : 0

  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "sms"
  endpoint  = var.alert_phone_number
}
