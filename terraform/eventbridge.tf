resource "aws_cloudwatch_event_rule" "security_events" {
  name        = "${var.project_name}-security-events"
  description = "Detect high-value AWS security events"

  event_pattern = jsonencode({
    source = [
      "aws.iam"
    ]
    "detail-type" = [
      "AWS API Call via CloudTrail"
    ]
    detail = {
      eventName = [
        "CreateUser",
        "DeleteUser",
        "CreateAccessKey",
        "DeleteAccessKey",
        "AttachUserPolicy",
        "DetachUserPolicy",
        "CreatePolicy",
        "DeletePolicy",
        "PutUserPolicy",
        "CreateRole",
        "DeleteRole",
        "UpdateAssumeRolePolicy"
      ]
    }
  })

  tags = {
    name = "Eventbridge-rules"
  }
}


resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.security_events.name
  target_id = "soc-lambda"

  arn = aws_lambda_function.soc_incident_report.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id = "AllowExecutionFromEventBridge"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.soc_incident_report.function_name
  principal     = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.security_events.arn
}
