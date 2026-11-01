variable "project_name" {
  description = "Project name used for naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC for the MLflow Postgres instance"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group. At least two AZs."
  type        = list(string)
}

variable "eks_cluster_security_group_id" {
  description = "Cluster security group AWS attaches to managed nodes. Not the unused Terraform node group SG."
  type        = string
}

variable "oidc_provider_arn" {
  description = "IAM OIDC provider ARN for this EKS cluster"
  type        = string
}

variable "oidc_issuer_url" {
  description = "EKS OIDC issuer URL, including https://"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Existing DVC artifacts bucket. MLflow may use only the mlflow/ prefix."
  type        = string
}

variable "postgres_engine_version" {
  description = "Pinned Postgres minor version"
  type        = string
}

variable "service_account_namespace" {
  description = "Namespace of the MLflow service account created in B3"
  type        = string
  default     = "mlflow"
}

variable "service_account_name" {
  description = "Name of the MLflow service account created in B3"
  type        = string
  default     = "mlflow"
}
