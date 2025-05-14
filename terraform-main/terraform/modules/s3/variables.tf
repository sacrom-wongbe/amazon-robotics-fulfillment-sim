variable "app_name" {
  type        = string
  description = "Application name prefix for S3 bucket naming"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod, etc.)"
}

variable "archive_bucket_name" {
  type        = string
  description = "Name of the archive S3 bucket"
}

variable "processed_bucket_name" {
  type        = string
  description = "Name of the processed S3 bucket"
}
