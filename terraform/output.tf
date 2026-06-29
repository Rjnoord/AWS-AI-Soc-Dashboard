output "aws_account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id

}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.current.region
}
