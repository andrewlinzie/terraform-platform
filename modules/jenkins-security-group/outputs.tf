output "security_group_id" {
  description = "Security group ID for Jenkins"
  value       = aws_security_group.jenkins.id
}
