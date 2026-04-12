resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = var.kubernetes_version

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.eks_cluster_security_group_id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = var.cluster_name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix            = "${var.project_name}-${var.environment}-eks-nodes-"
  key_name               = var.eks_node_ssh_key_name
  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_name}-${var.environment}-eks-node"
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks-node-lt"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids

  instance_types = var.node_instance_types

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = aws_launch_template.eks_nodes.default_version
  }

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = var.node_group_name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}

resource "aws_eks_access_entry" "cluster_admin" {
  count = var.enable_cluster_admin_access_entry ? 1 : 0

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.cluster_admin_principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  count = var.enable_cluster_admin_access_entry ? 1 : 0

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.cluster_admin_principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}