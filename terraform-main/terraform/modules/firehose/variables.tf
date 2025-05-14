variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "kinesis_stream_arn" {
  description = "ARN of the Kinesis data stream"
  type        = string
}

variable "firehose_s3_bucket" {
  description = "S3 bucket ARN for Firehose delivery"
  type        = string
}

variable "firehose_role_arn" {
  description = "IAM role ARN for Firehose"
  type        = string
}

variable "firehose_s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket where Firehose will store data"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}