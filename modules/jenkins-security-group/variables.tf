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
  description = "CIDR blocks allowed for SSH/admin access"
  type        = list(string)
}

variable "jenkins_web_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for Jenkins web ingress on port 8080"
  type        = list(string)
}