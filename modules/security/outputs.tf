output "eks_cluster_security_group_id" {
  description = "Security group ID for the EKS control plane"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_security_group_id" {
  description = "Security group ID for EKS worker nodes"
  value       = aws_security_group.eks_nodes.id
}

output "cms_security_group_id" {
  description = "Security group ID for CMS EC2"
  value       = aws_security_group.cms.id
}