locals {
  log_group_prefix = "/aws/${var.project_name}/${var.environment}"
}

resource "aws_cloudwatch_log_group" "api_service" {
  name              = "${local.log_group_prefix}/eks/api-service"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.environment}-api-service-logs"
    Environment = var.environment
    Service     = "api-service"
  }
}

resource "aws_cloudwatch_log_group" "ai_inference_service" {
  name              = "${local.log_group_prefix}/eks/ai-inference-service"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.environment}-ai-inference-service-logs"
    Environment = var.environment
    Service     = "ai-inference-service"
  }
}

resource "aws_cloudwatch_log_group" "cms_monolith" {
  name              = "${local.log_group_prefix}/ec2/cms-monolith"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.environment}-cms-monolith-logs"
    Environment = var.environment
    Service     = "cms-monolith"
  }
}

resource "aws_cloudwatch_log_group" "jenkins_deployments" {
  name              = "${local.log_group_prefix}/jenkins/cms-deployments"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.environment}-jenkins-deployment-logs"
    Environment = var.environment
    Service     = "jenkins"
  }
}

resource "aws_cloudwatch_metric_alarm" "cms_status_check_failed" {
  alarm_name          = "${var.project_name}-${var.environment}-cms-status-check-failed"
  alarm_description   = "Triggers when the CMS EC2 instance fails AWS status checks"
  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = var.cms_instance_id
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "${var.project_name}-${var.environment}-cms-status-check-failed"
    Environment = var.environment
    Service     = "cms-monolith"
    Severity    = "critical"
  }
}

resource "aws_cloudwatch_metric_alarm" "cms_cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-cms-cpu-high"
  alarm_description   = "Triggers when CMS EC2 CPU utilization is high"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    InstanceId = var.cms_instance_id
  }

  treat_missing_data = "notBreaching"

  tags = {
    Name        = "${var.project_name}-${var.environment}-cms-cpu-high"
    Environment = var.environment
    Service     = "cms-monolith"
    Severity    = "warning"
  }
}