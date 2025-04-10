variable "vpc_id" {}

resource "aws_security_group" "this" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
      description = "App Port 9090"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow from everywhere; for production, limit this.
  }
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowSSH"
  }
}

