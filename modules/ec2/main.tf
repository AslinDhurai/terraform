variable "subnet_id" {}
variable "sg_id" {}
variable "key_name" {}

resource "aws_instance" "this" {
  ami           = "ami-075686beab831bb7f"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name      = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "MyUbuntuInstance"
  }
}

