aws_region = "us-east-2"

project_name = "ai-cloud-platform"
environment  = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

availability_zones = [
  "us-east-2a",
  "us-east-2b"
]

cluster_name       = "ai-cloud-platform-dev-eks"
kubernetes_version = "1.33"

node_group_name     = "ai-cloud-platform-dev-node-group"
node_instance_types = ["t3.medium"]
node_desired_size   = 2
node_min_size       = 1
node_max_size       = 3

eks_node_ssh_key_name = null

cms_instance_type = "t3.medium"
cms_key_name      = "ai-cloud-platform-dev-cms-key"

enable_cluster_admin_access_entry = true
