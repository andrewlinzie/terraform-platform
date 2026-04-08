variable "aws_region" {
  description = "AWS region for this environment"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "repository_names" {
  description = "Shared ECR repository names (immutable artifacts used by dev/staging/prod)"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the shared VPC (Jenkins controller)"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets in the shared VPC"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets in the shared VPC"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnet placement"
  type        = list(string)
}

variable "trusted_cidr_blocks" {
  description = "CIDR blocks allowed to reach Jenkins (SSH and port 8080)"
  type        = list(string)
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for the Jenkins controller"
  type        = string
}

variable "jenkins_key_name" {
  description = "EC2 key pair name when jenkins_public_key is set (defaults to {project_name}-shared-jenkins-key)"
  type        = string
  default     = null
}

variable "jenkins_public_key" {
  description = "SSH public key for Jenkins EC2 key pair; leave empty to rely on SSM only"
  type        = string
  default     = ""
}
