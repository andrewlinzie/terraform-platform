variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. shared)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the Jenkins controller EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the Jenkins instance will be launched"
  type        = string
}

variable "jenkins_security_group_id" {
  description = "Security group ID for the Jenkins instance"
  type        = string
}

variable "jenkins_instance_profile_name" {
  description = "IAM instance profile name for Jenkins (least-privilege policies should be attached to the underlying role)"
  type        = string
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH access"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP (typical for a controller reachable for SSH/UI unless behind a load balancer)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for the Jenkins instance"
  type        = map(string)
  default     = {}
}
