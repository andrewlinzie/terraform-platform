locals {
  name       = "${var.project_name}-${var.environment}-mlflow"
  bucket_arn = "arn:aws:s3:::${var.artifacts_bucket_name}"
  oidc_host  = replace(var.oidc_issuer_url, "https://", "")
  sa_subject = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
}

resource "aws_db_subnet_group" "mlflow" {
  name       = local.name
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = local.name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "mlflow-tracking-db"
  }
}

resource "aws_security_group" "mlflow_db" {
  name        = "${local.name}-db"
  description = "Postgres for MLflow. Ingress only from the EKS cluster security group."
  vpc_id      = var.vpc_id

  ingress {
    description     = "Postgres from EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_cluster_security_group_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${local.name}-db"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_db_instance" "mlflow" {
  identifier        = local.name
  engine            = "postgres"
  engine_version    = var.postgres_engine_version
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "mlflow"
  username = "mlflow"

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.mlflow.name
  vpc_security_group_ids = [aws_security_group.mlflow_db.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period   = 7
  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${local.name}-final"

  auto_minor_version_upgrade = true
  apply_immediately          = true

  tags = {
    Name        = local.name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "mlflow-tracking-db"
  }
}

resource "aws_iam_role" "mlflow" {
  name = local.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_host}:aud" = "sts.amazonaws.com"
            "${local.oidc_host}:sub" = local.sa_subject
          }
        }
      }
    ]
  })

  tags = {
    Name        = local.name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "mlflow-irsa"
  }
}

resource "aws_iam_role_policy" "mlflow" {
  name = local.name
  role = aws_iam_role.mlflow.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "LocateBucket"
        Effect   = "Allow"
        Action   = ["s3:GetBucketLocation"]
        Resource = local.bucket_arn
      },
      {
        Sid      = "ListMlflowPrefix"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = local.bucket_arn
        Condition = {
          StringLike = {
            "s3:prefix" = ["mlflow", "mlflow/*"]
          }
        }
      },
      {
        Sid    = "WriteMlflowObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload"
        ]
        Resource = "${local.bucket_arn}/mlflow/*"
      },
      {
        Sid      = "ReadDbSecret"
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = aws_db_instance.mlflow.master_user_secret[0].secret_arn
      }
    ]
  })
}
