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

resource "aws_key_pair" "jenkins" {
  count = var.jenkins_public_key != "" ? 1 : 0

  key_name   = coalesce(var.jenkins_key_name, "${var.project_name}-shared-jenkins-key")
  public_key = var.jenkins_public_key

  tags = {
    Name        = coalesce(var.jenkins_key_name, "${var.project_name}-shared-jenkins-key")
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

module "jenkins_security_group" {
  source = "../../modules/jenkins-security-group"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  trusted_cidr_blocks = var.trusted_cidr_blocks
}

module "iam_jenkins" {
  source = "../../modules/iam-jenkins"

  project_name = var.project_name
  environment  = var.environment
}

module "ecr" {
  source = "../../modules/ecr"

  project_name     = var.project_name
  environment      = var.environment
  repository_names = var.repository_names
}

module "jenkins" {
  source = "../../modules/ec2-jenkins"

  project_name                  = var.project_name
  environment                   = var.environment
  ami_id                        = data.aws_ami.amazon_linux_2023.id
  instance_type                 = var.jenkins_instance_type
  subnet_id                     = module.vpc.public_subnet_ids[0]
  jenkins_security_group_id     = module.jenkins_security_group.security_group_id
  jenkins_instance_profile_name = module.iam_jenkins.jenkins_instance_profile_name
  key_name                      = length(aws_key_pair.jenkins) > 0 ? aws_key_pair.jenkins[0].key_name : null
}
