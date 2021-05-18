resource "aws_s3_bucket" "this" {
  bucket = "${var.prefix}-tfstate-${var.account_id}"
  acl    = "private"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
    noncurrent_version_expiration {
      days = 32
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.tags, { Name = "${var.prefix}-tfstate" })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "this" {
  name         = "${var.prefix}-tfstate"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    # S = String
    type = "S"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
