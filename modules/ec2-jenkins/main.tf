resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.jenkins_security_group_id]
  iam_instance_profile        = var.jenkins_instance_profile_name
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name

  tags = merge(
    {
      Name        = "${var.project_name}-${var.environment}-jenkins"
      Project     = var.project_name
      Environment = var.environment
      Role        = "jenkins-controller"
      ManagedBy   = "terraform"
    },
    var.tags,
  )
}
