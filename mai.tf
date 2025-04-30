resource "aws_s3_bucket" "logging_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "Logging Bucket"
  }
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/terraform/s3/logging_bucket_name"
  type  = "String"
  value = aws_s3_bucket.logging_bucket.id
}