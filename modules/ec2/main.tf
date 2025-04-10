variable "subnet_id" {}
variable "sg_id" {}

resource "aws_instance" "this" {
  ami           = "ami-075686beab831bb7f"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "MyUbuntuInstance"
  }
}

