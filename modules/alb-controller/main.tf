locals {
  name       = "${var.project_name}-${var.environment}-alb-controller"
  oidc_host  = replace(var.oidc_issuer_url, "https://", "")
  sa_subject = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
}

# Official IAM policy for controller v3.6.2.
# Source: https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v3.6.2/docs/install/iam_policy.json
# IAM ignores whitespace. The compact document is under the 6,144-character managed-policy limit.
resource "aws_iam_policy" "controller" {
  name        = local.name
  description = "AWS Load Balancer Controller v3.6.2. Official policy, pinned to the controller release."
  policy      = file("${path.module}/iam_policy.json")

  tags = {
    Name        = local.name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "alb-controller"
  }
}

resource "aws_iam_role" "controller" {
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
    Purpose     = "alb-controller"
  }
}

resource "aws_iam_role_policy_attachment" "controller" {
  role       = aws_iam_role.controller.name
  policy_arn = aws_iam_policy.controller.arn
}

resource "aws_security_group" "mlflow_alb" {
  name        = "${var.project_name}-${var.environment}-mlflow-alb"
  description = "MLflow ALB. HTTP from trusted admin CIDRs. Egress to pods on 5000 inside the VPC."
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from trusted admin CIDRs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidr_blocks
  }

  egress {
    description = "MLflow container port on pod IPs"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-mlflow-alb"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "mlflow-alb"
  }
}
