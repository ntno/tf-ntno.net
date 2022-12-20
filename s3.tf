resource "aws_s3_bucket" "backup_bucket" {
  bucket = format("bak.%s", var.portfolio_domain_name)
  tags   = local.global_tags
}

resource "aws_s3_bucket_versioning" "backup_bucket_versioning" {
  bucket = aws_s3_bucket.backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.backup_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}

resource "aws_s3_bucket" "artifacts_bucket" {
  bucket = format("artifacts.%s", var.portfolio_domain_name)
  tags   = local.global_tags
}

resource "aws_s3_bucket_acl" "artifacts_bucket_acl" {
  bucket = aws_s3_bucket.artifacts_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.artifacts_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}