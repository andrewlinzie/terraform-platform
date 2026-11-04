data "aws_caller_identity" "current" {}

data "aws_iam_openid_connect_provider" "github" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

locals {
  mlflow_read = var.mlflow_read == null ? {} : {
    (var.mlflow_read.policy_name) = var.mlflow_read
  }
}

resource "aws_iam_role" "ci" {
  for_each = var.repositories

  name = each.value.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:${var.github_org}/${each.value.github_repo}:ref:refs/heads/main",
              "repo:${var.github_org}/${each.value.github_repo}:pull_request",
            ]
          }
        }
      }
    ]
  })

  lifecycle {
    precondition {
      condition     = contains(keys(var.ecr_repository_arns), each.key)
      error_message = "No ECR ARN for CI repository ${each.key}."
    }
  }
}

resource "aws_iam_role_policy" "ecr_push" {
  for_each = var.repositories

  name = each.value.ecr_policy_name
  role = aws_iam_role.ci[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowECRAuth"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Sid    = each.value.push_sid
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
        ]
        Resource = var.ecr_repository_arns[each.key]
      }
    ]
  })
}

resource "aws_iam_role_policy" "mlflow_read" {
  for_each = local.mlflow_read

  name = each.key
  role = aws_iam_role.ci[each.value.repository_key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListMlflowPrefix"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = each.value.bucket_arn
        Condition = {
          StringLike = {
            "s3:prefix" = ["${each.value.prefix}/*"]
          }
        }
      },
      {
        Sid      = "ReadMlflowObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${each.value.bucket_arn}/${each.value.prefix}/*"
      }
    ]
  })
}
