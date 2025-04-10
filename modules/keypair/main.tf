resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "my-ec2-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key" {
  content              = tls_private_key.this.private_key_pem
  filename             = "${path.module}/my-ec2-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

