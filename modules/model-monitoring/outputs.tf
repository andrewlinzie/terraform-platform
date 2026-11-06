output "inference_role_arn" {
  description = "IAM role ARN trusted by service account apps/ai-inference-service"
  value       = aws_iam_role.inference.arn
}

output "inference_role_name" {
  description = "IAM role name for the inference prediction writer"
  value       = aws_iam_role.inference.name
}

output "drift_role_arn" {
  description = "IAM role ARN trusted by service account monitoring/model-drift"
  value       = aws_iam_role.drift.arn
}

output "drift_role_name" {
  description = "IAM role name for the drift job and exporter"
  value       = aws_iam_role.drift.name
}

output "predictions_prefix_uri" {
  description = "S3 URI prefix for sampled predictions"
  value       = "s3://${var.artifacts_bucket_name}/monitoring/predictions"
}

output "reference_prefix_uri" {
  description = "S3 URI prefix for frozen drift reference profiles"
  value       = "s3://${var.artifacts_bucket_name}/monitoring/reference"
}

output "reports_prefix_uri" {
  description = "S3 URI prefix for PSI reports"
  value       = "s3://${var.artifacts_bucket_name}/monitoring/reports"
}
