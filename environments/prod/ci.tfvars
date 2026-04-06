aws_region = "us-east-2"

project_name = "ai-cloud-platform"
environment  = "prod"

vpc_cidr = "10.2.0.0/16"

public_subnet_cidrs = [
  "10.2.1.0/24",
  "10.2.2.0/24"
]

private_subnet_cidrs = [
  "10.2.11.0/24",
  "10.2.12.0/24"
]

availability_zones = [
  "us-east-2a",
  "us-east-2b"
]

repository_names = [
  "api-service",
  "ai-inference-service",
  "cms-monolith"
]

cluster_name       = "ai-cloud-platform-prod-eks"
kubernetes_version = "1.33"

node_group_name     = "ai-cloud-platform-prod-node-group"
node_instance_types = ["t3.medium"]
node_desired_size   = 3
node_min_size       = 2
node_max_size       = 5

eks_node_ssh_key_name = null

cms_instance_type = "t3.large"
cms_key_name      = "ai-cloud-platform-prod-cms-key"