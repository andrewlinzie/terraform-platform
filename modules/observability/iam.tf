resource "aws_iam_policy" "cloudwatch_agent" {
  name        = "${var.project_name}-${var.environment}-cloudwatch-agent-policy"
  description = "Allows CMS EC2 instance to publish logs and metrics to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}