output "archive_bucket_arn" {
  value = aws_s3_bucket.archive.arn
}

output "processed_bucket_arn" {
  value = aws_s3_bucket.processed.arn
}
