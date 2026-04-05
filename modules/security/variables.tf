variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "trusted_cidr_blocks" {
  description = "CIDR blocks allowed to access the CMS for admin/testing"
  type        = list(string)
}