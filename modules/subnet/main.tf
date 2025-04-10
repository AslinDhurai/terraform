variable "vpc_id" {}

resource "aws_subnet" "this" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "MySubnet"
  }
}

