data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_key_pair" "cms" {
  key_name   = var.cms_key_name
  public_key = var.cms_public_key

  tags = {
    Name        = var.cms_key_name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "../../modules/security"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  trusted_cidr_blocks = var.trusted_cidr_blocks
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "eks" {
  source = "../../modules/eks"

  project_name                  = var.project_name
  environment                   = var.environment
  cluster_name                  = var.cluster_name
  kubernetes_version            = var.kubernetes_version
  private_subnet_ids            = module.vpc.private_subnet_ids
  eks_cluster_role_arn          = module.iam.eks_cluster_role_arn
  eks_node_role_arn             = module.iam.eks_node_role_arn
  eks_cluster_security_group_id = module.security.eks_cluster_security_group_id
  eks_nodes_security_group_id   = module.security.eks_nodes_security_group_id
  node_group_name               = var.node_group_name
  node_instance_types           = var.node_instance_types
  node_desired_size             = var.node_desired_size
  node_min_size                 = var.node_min_size
  node_max_size                 = var.node_max_size
  eks_node_ssh_key_name         = var.eks_node_ssh_key_name
}

module "ec2_cms" {
  source = "../../modules/ec2-cms"

  depends_on = [aws_key_pair.cms]

  project_name              = var.project_name
  environment               = var.environment
  ami_id                    = data.aws_ami.amazon_linux_2023.id
  instance_type             = var.cms_instance_type
  subnet_id                 = module.vpc.public_subnet_ids[0]
  cms_security_group_id     = module.security.cms_security_group_id
  cms_instance_profile_name = module.iam.cms_instance_profile_name
  key_name                  = var.cms_key_name
}