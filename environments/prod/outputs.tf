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