output "role_arns" {
  description = "CI role ARNs keyed by ECR repository name"
  value       = { for key, role in aws_iam_role.ci : key => role.arn }
}
