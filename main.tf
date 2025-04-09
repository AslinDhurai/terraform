provider "aws" {
  region = "us-west-2"   # Choose your AWS region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-s3-bucket-name-12345"  # Bucket name must be globally unique
}

