# Bucket
resource "aws_s3_bucket" "sandbox_bucket" {
  bucket = join("", [var.bucket_name, "-", formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())])
  acl    = var.acl_value

  tags = {
    environment = "sandbox"
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = var.logging_prefix
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = join("", [var.log_bucket_name, "-", formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())])
  acl    = var.acl_value
}