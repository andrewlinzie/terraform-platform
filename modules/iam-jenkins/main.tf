resource "aws_iam_role" "jenkins_ec2_role" {
  name = "${var.project_name}-${var.environment}-jenkins-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-jenkins-ec2-role"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_ssm_core" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Push/pull images to shared ECR from the Jenkins controller (pipeline docker push).
resource "aws_iam_role_policy_attachment" "jenkins_ecr_poweruser" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.project_name}-${var.environment}-jenkins-instance-profile"
  role = aws_iam_role.jenkins_ec2_role.name

  tags = {
    Name        = "${var.project_name}-${var.environment}-jenkins-instance-profile"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
