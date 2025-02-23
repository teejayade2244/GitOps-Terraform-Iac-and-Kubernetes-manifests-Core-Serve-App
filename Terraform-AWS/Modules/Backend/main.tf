# this create an S3 bucket for remote backend
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion of the bucket
  }
  tags = {
    Name        = var.bucket_name
    description = var.bucket_description
  }
}


resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Dynamo DB for remote-backend
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamo_db_name_remote-backend
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }
  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion of the table
  }
}