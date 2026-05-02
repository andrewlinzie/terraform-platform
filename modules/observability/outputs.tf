output "api_service_log_group_name" {
  value = aws_cloudwatch_log_group.api_service.name
}

output "ai_inference_service_log_group_name" {
  value = aws_cloudwatch_log_group.ai_inference_service.name
}

output "cms_monolith_log_group_name" {
  value = aws_cloudwatch_log_group.cms_monolith.name
}

output "jenkins_deployments_log_group_name" {
  value = aws_cloudwatch_log_group.jenkins_deployments.name
}

output "cloudwatch_agent_policy_arn" {
  value = aws_iam_policy.cloudwatch_agent.arn
}