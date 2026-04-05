variable "aws_region" {
  description = "AWS region for Terraform backend resources"
  type        = string
}

variable "tf_state_bucket_name" {
  description = "S3 bucket name for Terraform remote state"
  type        = string
}

variable "tf_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment label for bootstrap resources"
  type        = string
  default     = "shared"
}