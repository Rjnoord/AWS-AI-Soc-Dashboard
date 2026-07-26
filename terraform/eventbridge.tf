# EventBridge: filters CloudTrail's full API-call firehose down to only the
# privileged IAM actions worth alerting on, then fans the match out to Lambda.

# Rule matches high-value IAM changes (user/key/policy/role create-delete-
# modify) so we don't fire the Lambda on every routine API call CloudTrail logs.
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


# Wires the matched-event rule to the incident-report Lambda as its invocation target.
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.security_events.name
  target_id = "soc-lambda"

  arn = aws_lambda_function.soc_incident_report.arn
}

# Grants EventBridge permission to invoke the Lambda; without this the rule
# target above is configured but AWS will silently refuse to call the function.
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id = "AllowExecutionFromEventBridge"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.soc_incident_report.function_name
  principal     = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.security_events.arn
}
