# Adopt roles that already exist. The first shared apply imports them, then
# adds ecr:BatchGetImage and ecr:GetDownloadUrlForLayer in place.
# A plan that destroys either role is wrong: GitHub secrets point at these ARNs.

import {
  to = module.github_actions_ci.aws_iam_role.ci["ai-inference-service"]
  id = "github-actions-ai-inference-service-dev"
}

import {
  to = module.github_actions_ci.aws_iam_role_policy.ecr_push["ai-inference-service"]
  id = "github-actions-ai-inference-service-dev:ai-inference-service-ecr-push-dev"
}

import {
  to = module.github_actions_ci.aws_iam_role_policy.mlflow_read["ai-inference-read-mlflow"]
  id = "github-actions-ai-inference-service-dev:ai-inference-read-mlflow"
}

import {
  to = module.github_actions_ci.aws_iam_role.ci["api-service"]
  id = "github-actions-api-service-dev"
}

import {
  to = module.github_actions_ci.aws_iam_role_policy.ecr_push["api-service"]
  id = "github-actions-api-service-dev:api-service-ecr-push-dev"
}
