output "jenkins_instance_profile_name" {
  description = "IAM instance profile name for Jenkins EC2"
  value       = aws_iam_instance_profile.jenkins.name
}

output "jenkins_role_arn" {
  description = "IAM role ARN for Jenkins EC2"
  value       = aws_iam_role.jenkins_ec2_role.arn
}
