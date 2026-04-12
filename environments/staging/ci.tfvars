aws_region = "us-east-2"

project_name = "ai-cloud-platform"
environment  = "staging"

vpc_cidr = "10.1.0.0/16"

public_subnet_cidrs = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]

private_subnet_cidrs = [
  "10.1.11.0/24",
  "10.1.12.0/24"
]

availability_zones = [
  "us-east-2a",
  "us-east-2b"
]

cluster_name       = "ai-cloud-platform-staging-eks"
kubernetes_version = "1.33"

node_group_name     = "ai-cloud-platform-staging-node-group"
node_instance_types = ["t3.medium"]
node_desired_size   = 2
node_min_size       = 1
node_max_size       = 4

eks_node_ssh_key_name = null

cms_instance_type = "t3.medium"
cms_key_name      = "ai-cloud-platform-staging-cms-key"

enable_cluster_admin_access_entry = true
