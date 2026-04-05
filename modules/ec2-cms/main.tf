resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.cms_security_group_id]
  iam_instance_profile        = var.cms_instance_profile_name
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-cms"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}