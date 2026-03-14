provider "aws" {
  region = "us-east-1"
}

# IAM USER
resource "aws_iam_user" "bob" {
  name = "Bob"
}

# S3 BUCKET (NON CIS - public)
resource "aws_s3_bucket" "cis_bucket" {
  bucket = "cis-bucket-11090"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.cis_bucket.id

  block_public_acls   = false
  block_public_policy = false
}

# VPC
resource "aws_vpc" "cis_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cis-vpc"
  }
}

# EC2 INSTANCE
resource "aws_instance" "cis_server" {
  ami           = "ami-0a14f53a6fe4dfcd1"
  instance_type = "t3.micro"

  tags = {
    Name = "cis-server"
  }
}
