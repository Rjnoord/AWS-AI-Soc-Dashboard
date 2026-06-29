resource "aws_cloudwatch_dashboard" "soc_dashboard" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 3

        properties = {
          markdown = "# AWS AI SOC Dashboard\nSecurity monitoring dashboard for CloudTrail, EventBridge, Lambda, SNS, and future Bedrock AI incident summaries."
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 3
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Events", "MatchedEvents", "RuleName", aws_cloudwatch_event_rule.iam_security_events.name]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "IAM Security Events Detected"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 3
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.soc_incident_processor.function_name],
            [".", "Errors", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "SOC Lambda Invocations and Errors"
        }
      }
    ]
  })
}

