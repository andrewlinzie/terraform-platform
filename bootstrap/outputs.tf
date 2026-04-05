output "tf_state_bucket_name" {
  description = "Name of the Terraform state bucket"
  value       = aws_s3_bucket.tf_state.bucket
}

output "tf_lock_table_name" {
  description = "Name of the Terraform lock table"
  value       = aws_dynamodb_table.tf_locks.name
}

output "aws_region" {
  description = "Region used for backend resources"
  value       = var.aws_region
}