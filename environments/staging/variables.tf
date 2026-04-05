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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnet placement"
  type        = list(string)
}

variable "trusted_cidr_blocks" {
  description = "CIDR blocks allowed to access the CMS"
  type        = list(string)
}

variable "repository_names" {
  description = "List of ECR repositories to create"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "node_instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
}

variable "node_desired_size" {
  description = "Desired number of EKS nodes"
  type        = number
}

variable "node_min_size" {
  description = "Minimum number of EKS nodes"
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of EKS nodes"
  type        = number
}

variable "cms_instance_type" {
  description = "Instance type for CMS EC2"
  type        = string
}

variable "cms_key_name" {
  description = "Optional EC2 key pair name for CMS"
  type        = string
  default     = null
}

variable "eks_node_ssh_key_name" {
  description = "Optional key pair name for EKS worker nodes"
  type        = string
  default     = null
}

variable "cms_public_key" {
  description = "SSH public key material used to create the CMS EC2 key pair"
  type        = string
}