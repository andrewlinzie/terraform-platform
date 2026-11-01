output "db_endpoint" {
  description = "RDS hostname (no port)"
  value       = aws_db_instance.mlflow.address
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.mlflow.port
}

output "db_name" {
  description = "Postgres database name"
  value       = aws_db_instance.mlflow.db_name
}

output "db_username" {
  description = "Postgres master username. The password is not in Terraform state."
  value       = aws_db_instance.mlflow.username
}

output "db_secret_arn" {
  description = "Secrets Manager ARN of the RDS-managed master password"
  value       = aws_db_instance.mlflow.master_user_secret[0].secret_arn
}

output "irsa_role_arn" {
  description = "IAM role ARN trusted by service account mlflow/mlflow"
  value       = aws_iam_role.mlflow.arn
}

output "artifacts_prefix_uri" {
  description = "S3 URI prefix for MLflow artifacts"
  value       = "s3://${var.artifacts_bucket_name}/mlflow"
}
