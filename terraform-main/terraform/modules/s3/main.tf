resource "aws_s3_bucket" "archive" {
  bucket        = "${var.app_name}-firehose-archive-${var.environment}"
  force_destroy = true

  tags = {
    Environment = var.environment
    Purpose     = "raw-ingest-archive"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "archive" {
  bucket = aws_s3_bucket.archive.id

  rule {
    id     = "transition-to-glacier"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 10
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket" "processed" {
  bucket        = "${var.app_name}-analytics-csv-${var.environment}"
  force_destroy = true

  tags = {
    Environment = var.environment
    Purpose     = "processed-analytics"
  }
}
