output "environment" {
  description = "Stack environment name (shared)"
  value       = var.environment
}

output "ecr_repository_urls" {
  description = "Repository URLs for shared ECR repositories"
  value       = module.ecr.repository_urls
}

output "ecr_repository_names" {
  description = "Shared ECR repository names"
  value       = module.ecr.repository_names
}

output "ecr_repository_arns" {
  description = "Repository ARNs for shared ECR repositories"
  value       = module.ecr.repository_arns
}

output "jenkins_instance_id" {
  description = "Jenkins controller EC2 instance ID"
  value       = module.jenkins.instance_id
}

output "jenkins_public_ip" {
  description = "Jenkins controller public IP"
  value       = module.jenkins.public_ip
}

output "jenkins_private_ip" {
  description = "Jenkins controller private IP"
  value       = module.jenkins.private_ip
}

output "shared_vpc_id" {
  description = "VPC ID for the shared (Jenkins) network"
  value       = module.vpc.vpc_id
}
