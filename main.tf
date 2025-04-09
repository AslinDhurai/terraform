provider "aws" {
  region = "us-west-2"   # Choose your AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "myawsbucket4016my"  # Bucket name must be globally unique
}

resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-075686beab831bb7f"   # Ubuntu Server 22.04 LTS AMI ID for us-west-2 (Oregon)
  instance_type = "t2.micro"

  tags = {
    Name = "MyUbuntuInstance"
  }
}
