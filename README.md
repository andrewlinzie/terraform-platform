# terraform-platform

## Purpose
Defines and provisions AWS infrastructure using Terraform.

## Contains
- Terraform modules (VPC, EKS, EC2, IAM, ECR)
- Environment-specific configurations
- Remote backend configuration (S3 + DynamoDB)
- Infrastructure CI/CD workflow

## Does Not Contain
- Application source code
- GitOps deployment state
- Dockerfiles
- Jenkins deployment logic

## Future Phases
- CI pipeline (validate, plan, apply)
- OIDC authentication
- Environment-based deployment controls
