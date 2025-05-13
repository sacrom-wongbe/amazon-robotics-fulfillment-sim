resource "aws_s3_bucket" "archive" {
  bucket = "${var.app_name}-firehose-archive-${var.environment}"
  force_destroy = true

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = true

    transition {
      days          = 10
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

  tags = {
    Environment = var.environment
    Purpose     = "raw-ingest-archive"
  }
}

resource "aws_s3_bucket" "processed" {
  bucket = "${var.app_name}-analytics-csv-${var.environment}"
  force_destroy = true

  tags = {
    Environment = var.environment
    Purpose     = "processed-analytics"
  }
}
