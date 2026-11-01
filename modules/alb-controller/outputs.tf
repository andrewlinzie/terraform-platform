output "irsa_role_arn" {
  description = "IAM role ARN trusted by service account kube-system/aws-load-balancer-controller"
  value       = aws_iam_role.controller.arn
}

output "mlflow_alb_security_group_id" {
  description = "Security group the MLflow Ingress attaches to the ALB. HTTP from trusted CIDRs only."
  value       = aws_security_group.mlflow_alb.id
}
