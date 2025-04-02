# this create an S3 bucket for remote backend
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion of the bucket
  }
  tags = {
    Name        = var.bucket_name
    description = var.bucket_description
  }
}


resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
