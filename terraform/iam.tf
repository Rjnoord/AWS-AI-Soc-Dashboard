# IAM wiring that lets CloudTrail push its event stream into CloudWatch Logs
# (see cloudtrail.tf's cloud_watch_logs_* args), which is what feeds EventBridge.

# Trust policy allowing the CloudTrail service to assume the role below.
data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Role CloudTrail assumes to write its own logs into CloudWatch for
# near-real-time visibility (distinct from the S3 write, which is delivery
# via bucket policy, not this role).
resource "aws_iam_role" "cloudtrail_role" {
  name = "${var.project_name}-cloudtrail-role"

  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
}

# Least-privilege permissions: only create/write into this specific log
# group's streams, nothing broader.
resource "aws_iam_policy" "cloudtrail_cloudwatch_policy" {
  name        = "${var.project_name}-cloudtrail-cloudwatch-policy"
  description = "Allows CloudTrail to publish logs to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:log-stream:*"
      }
    ]
  })
}

# Attaches the CloudWatch-write policy to the CloudTrail role.
resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_policy" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_policy.arn
}
