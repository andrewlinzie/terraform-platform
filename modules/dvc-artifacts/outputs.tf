output "bucket_id" {
  description = "DVC artifacts S3 bucket name"
  value       = aws_s3_bucket.dvc.id
}

output "bucket_arn" {
  description = "DVC artifacts S3 bucket ARN"
  value       = aws_s3_bucket.dvc.arn
}

output "bucket_region" {
  description = "Region for the DVC artifacts bucket"
  value       = aws_s3_bucket.dvc.region
}