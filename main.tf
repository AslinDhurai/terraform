provider "aws" {
  region = "us-west-2"   # Choose your AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "myawsbucket4016my"  # Bucket name must be globally unique
}

