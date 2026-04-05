variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the CMS EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the CMS"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the CMS instance will be launched"
  type        = string
}

variable "cms_security_group_id" {
  description = "Security group ID for the CMS instance"
  type        = string
}

variable "cms_instance_profile_name" {
  description = "IAM instance profile name for the CMS"
  type        = string
}

variable "key_name" {
  description = "Optional EC2 key pair name"
  type        = string
  default     = null
}