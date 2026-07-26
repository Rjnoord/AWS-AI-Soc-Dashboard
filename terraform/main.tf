# Shared account/region context used to name and scope resources (e.g. the
# CloudTrail S3 bucket name includes the account ID to guarantee uniqueness).

# Identifies the AWS account this config is deployed into.
data "aws_caller_identity" "current" {}

# Region the provider is operating in, referenced by the dashboard widgets.
data "aws_region" "current" {}
  