# CloudTrail's log destination. These logs record all account activity, so
# the bucket is locked down: no public access, versioned, and encrypted at rest.

# Bucket CloudTrail writes into; account ID suffix keeps the name globally unique.
resource "aws_s3_bucket" "soc_dashboard_logs" {
  bucket = "${var.project_name}-cloudtrail-logs-${data.aws_caller_identity.current.account_id}"

  tags = {
    name = "soc-dashboard-logs"
  }
}

# Versioning protects the audit trail from accidental overwrite/deletion.
resource "aws_s3_bucket_versioning" "soc_dashboard_logs_v2" {
  bucket = aws_s3_bucket.soc_dashboard_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Belt-and-suspenders block on public access — these logs contain account
# activity and must never be exposed, regardless of any future bucket/object ACLs.
resource "aws_s3_bucket_public_access_block" "soc_dashboard_logs" {
  bucket = aws_s3_bucket.soc_dashboard_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encrypts log objects at rest by default.
resource "aws_s3_bucket_server_side_encryption_configuration" "soc_dashboard_logs" {
  bucket = aws_s3_bucket.soc_dashboard_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
