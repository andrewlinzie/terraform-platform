variable "project_name" {
  description = "Project name used for naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
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
  description = "Existing DVC artifacts bucket. This module may use only the monitoring/ prefix."
  type        = string
}

variable "inference_service_account_namespace" {
  description = "Namespace of the inference service account that writes prediction samples"
  type        = string
  default     = "apps"
}

variable "inference_service_account_name" {
  description = "Name of the inference service account that writes prediction samples"
  type        = string
  default     = "ai-inference-service"
}

variable "drift_service_account_namespace" {
  description = "Namespace of the drift job service account"
  type        = string
  default     = "monitoring"
}

variable "drift_service_account_name" {
  description = "Name of the drift job service account"
  type        = string
  default     = "model-drift"
}
