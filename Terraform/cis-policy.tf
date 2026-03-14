# IAM Policy
resource "aws_iam_user_policy" "mfa_enforce" {
  name = "bob-mfa-policy"
  user = aws_iam_user.bob.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Deny"
      Action = "*"
      Resource = "*"
      Condition = {
        BoolIfExists = {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }]
  })
}
  
# S3 CIS Policy
resource "aws_s3_bucket_server_side_encryption_configuration" "enc" {
  bucket = aws_s3_bucket.cis_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "secure_block" {
  bucket = aws_s3_bucket.cis_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

# EC2 Policy
resource "aws_instance" "cis_server" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "cis-server"
  }
}

# VPC Policy
resource "aws_flow_log" "vpc_flow" {
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.cis_vpc.id
}
