output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "Internet gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "NAT gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "eks_cluster_security_group_id" {
  description = "Security group ID for EKS control plane"
  value       = module.security.eks_cluster_security_group_id
}

output "eks_nodes_security_group_id" {
  description = "Security group ID for EKS worker nodes"
  value       = module.security.eks_nodes_security_group_id
}

output "cms_security_group_id" {
  description = "Security group ID for CMS EC2"
  value       = module.security.cms_security_group_id
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  value       = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  value       = module.iam.eks_node_role_arn
}

output "cms_instance_profile_name" {
  description = "Instance profile name for CMS EC2"
  value       = module.iam.cms_instance_profile_name
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_node_group_name" {
  description = "EKS node group name"
  value       = module.eks.node_group_name
}

output "cms_instance_id" {
  description = "CMS EC2 instance ID"
  value       = module.ec2_cms.instance_id
}

output "cms_public_ip" {
  description = "CMS EC2 public IP"
  value       = module.ec2_cms.public_ip
}

output "eks_cluster_managed_security_group_id" {
  description = "Security group AWS attaches to managed nodes. MLflow Postgres allows 5432 from this group."
  value       = module.eks.cluster_security_group_id
}

output "mlflow_db_endpoint" {
  description = "MLflow RDS hostname"
  value       = module.mlflow_backing.db_endpoint
}

output "mlflow_db_secret_arn" {
  description = "Secrets Manager ARN for the MLflow RDS master password"
  value       = module.mlflow_backing.db_secret_arn
}

output "mlflow_irsa_role_arn" {
  description = "IAM role ARN for the MLflow service account"
  value       = module.mlflow_backing.irsa_role_arn
}

output "mlflow_artifacts_prefix_uri" {
  description = "S3 URI prefix for MLflow artifacts"
  value       = module.mlflow_backing.artifacts_prefix_uri
}

output "alb_controller_irsa_role_arn" {
  description = "IAM role ARN for the AWS Load Balancer Controller service account"
  value       = module.alb_controller.irsa_role_arn
}

output "mlflow_alb_security_group_id" {
  description = "Security group id to put on the MLflow Ingress. Do not commit the CIDRs."
  value       = module.alb_controller.mlflow_alb_security_group_id
}

output "inference_prediction_log_role_arn" {
  description = "IAM role ARN for the inference service account that writes monitoring/predictions"
  value       = module.model_monitoring.inference_role_arn
}

output "model_drift_role_arn" {
  description = "IAM role ARN for the model drift job and exporter"
  value       = module.model_monitoring.drift_role_arn
}