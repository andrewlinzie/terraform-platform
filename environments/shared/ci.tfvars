aws_region = "us-east-2"

project_name = "ai-cloud-platform"
environment  = "shared"

repository_names = [
  "api-service",
  "ai-inference-service",
  "cms-monolith",
]

vpc_cidr = "10.3.0.0/16"

public_subnet_cidrs = [
  "10.3.1.0/24",
  "10.3.2.0/24",
]

private_subnet_cidrs = [
  "10.3.11.0/24",
  "10.3.12.0/24",
]

availability_zones = [
  "us-east-2a",
  "us-east-2b",
]

jenkins_instance_type = "t3.medium"

# EC2 key pair name for SSH to Jenkins (same pattern as cms_key_name in tier envs).
# Set jenkins_public_key in terraform.tfvars locally, or TF_VAR_jenkins_public_key in CI (see README).
jenkins_key_name = "ai-cloud-platform-shared-jenkins-key"
