output "archive_bucket_arn" {
  value       = aws_s3_bucket.archive.arn
  description = "ARN of the archive S3 bucket"
}

output "archive_bucket_name" {
  value       = aws_s3_bucket.archive.bucket
  description = "Name of the archive S3 bucket"
}

output "processed_bucket_arn" {
  value       = aws_s3_bucket.processed.arn
  description = "ARN of the processed S3 bucket"
}

output "processed_bucket_name" {
  value       = aws_s3_bucket.processed.bucket
  description = "Name of the processed S3 bucket"
}
