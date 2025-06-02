# this create an S3 bucket for remote backend
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge({
    Name        = var.bucket_name
    Description = var.bucket_description
  }, var.tags)
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.versioning ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  count  = var.encryption ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
