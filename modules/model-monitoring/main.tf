locals {
  oidc_host  = replace(var.oidc_issuer_url, "https://", "")
  bucket_arn = "arn:aws:s3:::${var.artifacts_bucket_name}"

  inference_name    = "${var.project_name}-${var.environment}-inference"
  inference_subject = "system:serviceaccount:${var.inference_service_account_namespace}:${var.inference_service_account_name}"

  drift_name    = "${var.project_name}-${var.environment}-model-drift"
  drift_subject = "system:serviceaccount:${var.drift_service_account_namespace}:${var.drift_service_account_name}"

  list_prefixes = [
    "monitoring/predictions",
    "monitoring/predictions/*",
    "monitoring/reference",
    "monitoring/reference/*",
    "monitoring/reports",
    "monitoring/reports/*",
  ]
}

resource "aws_iam_role" "inference" {
  name = local.inference_name

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
            "${local.oidc_host}:sub" = local.inference_subject
          }
        }
      }
    ]
  })

  tags = {
    Name        = local.inference_name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "inference-prediction-log"
  }
}

resource "aws_iam_role_policy" "inference" {
  name = local.inference_name
  role = aws_iam_role.inference.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "WritePredictionSamples"
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${local.bucket_arn}/monitoring/predictions/*"
      }
    ]
  })
}

resource "aws_iam_role" "drift" {
  name = local.drift_name

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
            "${local.oidc_host}:sub" = local.drift_subject
          }
        }
      }
    ]
  })

  tags = {
    Name        = local.drift_name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Purpose     = "model-drift"
  }
}

resource "aws_iam_role_policy" "drift" {
  name = local.drift_name
  role = aws_iam_role.drift.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListMonitoringPrefixes"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = local.bucket_arn
        Condition = {
          StringLike = {
            "s3:prefix" = local.list_prefixes
          }
        }
      },
      {
        Sid    = "ReadSamplesReferenceAndReports"
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = [
          "${local.bucket_arn}/monitoring/predictions/*",
          "${local.bucket_arn}/monitoring/reference/*",
          "${local.bucket_arn}/monitoring/reports/*",
        ]
      },
      {
        Sid      = "WriteDriftReports"
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${local.bucket_arn}/monitoring/reports/*"
      }
    ]
  })
}
