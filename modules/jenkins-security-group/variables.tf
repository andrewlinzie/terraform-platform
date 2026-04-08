variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the Jenkins security group"
  type        = string
}

variable "trusted_cidr_blocks" {
  description = "CIDR blocks allowed to reach Jenkins (SSH and UI)"
  type        = list(string)
}
