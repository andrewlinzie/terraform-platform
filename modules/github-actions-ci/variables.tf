variable "github_org" {
  description = "GitHub organization or user that owns the service repositories"
  type        = string
}

variable "ecr_repository_arns" {
  description = "ECR repository name to ARN"
  type        = map(string)
}

variable "repositories" {
  description = "One CI role per service repository. The role name must stay stable; GitHub secrets already point at it."
  type = map(object({
    role_name       = string
    github_repo     = string
    ecr_policy_name = string
    push_sid        = string
  }))
}

variable "mlflow_read" {
  description = "Optional read of one S3 prefix for a single CI role. Null when no role bakes a model."
  type = object({
    repository_key = string
    policy_name    = string
    bucket_arn     = string
    prefix         = string
  })
  default = null
}
