variable "project_name" {
  description = "Project name used for naming observability resources"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 14
}

variable "cms_instance_id" {
  description = "EC2 instance ID for the CMS host"
  type        = string
}