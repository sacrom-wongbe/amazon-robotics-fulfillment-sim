variable "app_name" {
  type        = string
  description = "Application name prefix for S3 bucket naming"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod, etc.)"
}
