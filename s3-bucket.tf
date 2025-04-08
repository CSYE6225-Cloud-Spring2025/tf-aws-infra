resource "random_uuid" "bucket_uuid" {}

resource "aws_s3_bucket" "upload_bucket" {
  bucket        = "upload-bucket-${formatdate("YYYYMMDD", timestamp())}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.upload_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_private" {
  bucket                  = aws_s3_bucket.upload_bucket.id
  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.upload_bucket.id
  rule {
    id = "transition-to-ia"
    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }
    status = "Enabled"
  }
}