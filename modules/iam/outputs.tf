output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "ARN of the EKS node IAM role"
  value       = aws_iam_role.eks_node_role.arn
}

output "cms_ec2_role_name" {
  description = "Name of the CMS EC2 IAM role"
  value       = aws_iam_role.cms_ec2_role.name
}

output "cms_instance_profile_name" {
  description = "Name of the CMS EC2 instance profile"
  value       = aws_iam_instance_profile.cms_instance_profile.name
}

output "cms_instance_profile_arn" {
  description = "ARN of the CMS EC2 instance profile"
  value       = aws_iam_instance_profile.cms_instance_profile.arn
}