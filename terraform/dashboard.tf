# Single-pane operational view of the pipeline so an analyst can see, at a
# glance, how many privileged IAM events fired and whether the processing
# Lambda is keeping up (or erroring out) without digging through logs.
resource "aws_cloudwatch_dashboard" "soc_dashboard" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        # Header/title widget, no metrics.
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
        # Volume of EventBridge matches: how many privileged IAM actions
        # triggered the rule, i.e. how "busy" the SOC pipeline has been.
        type   = "metric"
        x      = 0
        y      = 3
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Events", "MatchedEvents", "RuleName", aws_cloudwatch_event_rule.security_events.name]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "IAM Security Events Detected"
        }
      },
      {
        # Health of the incident-report Lambda: invocation count vs. errors,
        # so a spike in errors (e.g. Bedrock throttling) is visible fast.
        type   = "metric"
        x      = 12
        y      = 3
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.soc_incident_report.function_name],
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
