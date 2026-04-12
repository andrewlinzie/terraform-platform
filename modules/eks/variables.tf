variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS cluster and node group"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for the EKS control plane"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  type        = string
}

variable "eks_cluster_security_group_id" {
  description = "Security group ID for EKS control plane"
  type        = string
}

variable "eks_nodes_security_group_id" {
  description = "Security group ID for EKS worker nodes"
  type        = string
}

variable "node_group_name" {
  description = "Name of the managed node group"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS worker nodes"
  type        = list(string)
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "eks_node_ssh_key_name" {
  description = "Optional EC2 key pair name for EKS worker nodes"
  type        = string
  default     = null
}

variable "enable_cluster_admin_access_entry" {
  description = "Whether to create an EKS access entry granting cluster-admin permissions"
  type        = bool
  default     = false
}

variable "cluster_admin_principal_arn" {
  description = "IAM principal ARN to grant cluster-admin access to the EKS cluster"
  type        = string
  default     = null
}