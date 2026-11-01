variable "project_name" {
  description = "Project name used for naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the MLflow ALB security group is created"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR. The ALB may open egress only to this range."
  type        = string
}

variable "trusted_cidr_blocks" {
  description = "Admin CIDRs allowed to open HTTP to the MLflow ALB. Same list as the rest of the dev stack."
  type        = list(string)
}

variable "oidc_provider_arn" {
  description = "IAM OIDC provider ARN for this EKS cluster"
  type        = string
}

variable "oidc_issuer_url" {
  description = "EKS OIDC issuer URL, including https://"
  type        = string
}

variable "service_account_namespace" {
  description = "Namespace of the AWS Load Balancer Controller service account"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Name of the AWS Load Balancer Controller service account"
  type        = string
  default     = "aws-load-balancer-controller"
}
