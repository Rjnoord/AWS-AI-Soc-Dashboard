# Grants the CloudTrail service write access to the logs bucket defined in
# s3.tf. Without this policy, CloudTrail's delivery of log files would be
# denied by the bucket's default private access.

# Bucket policy that lets the CloudTrail service (and only that service)
# write log files into the logs bucket, scoped to CloudTrail's own prefix.
data "aws_iam_policy_document" "cloudtrail_s3_bucket_policy" {
  statement {
    # CloudTrail checks the bucket ACL before it starts delivering logs.
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.soc_dashboard_logs.arn]
  }

  statement {
    # Actual log delivery permission, restricted to this account's
    # AWSLogs/<account-id>/ prefix so CloudTrail can't write anywhere else.
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.soc_dashboard_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    # Requires CloudTrail to grant the bucket owner full control over the
    # objects it writes, so RJ's account (not CloudTrail's) owns the logs.
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# Attaches the above policy document to the logs bucket.
resource "aws_s3_bucket_policy" "cloudtrail_logs" {
  bucket = aws_s3_bucket.soc_dashboard_logs.id
  policy = data.aws_iam_policy_document.cloudtrail_s3_bucket_policy.json
}
