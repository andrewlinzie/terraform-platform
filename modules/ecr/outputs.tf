output "repository_urls" {
  description = "Map of repository names to repository URLs"
  value = {
    for repo_name, repo in aws_ecr_repository.repos :
    repo_name => repo.repository_url
  }
}

output "repository_arns" {
  description = "Map of repository names to repository ARNs"
  value = {
    for repo_name, repo in aws_ecr_repository.repos :
    repo_name => repo.arn
  }
}

output "repository_names" {
  description = "List of repository names created"
  value       = keys(aws_ecr_repository.repos)
}