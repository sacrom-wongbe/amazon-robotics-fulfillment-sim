variable "eks_worker_role_name" {
  description = "Name of the IAM role used by EKS worker nodes"
  type        = string
}

variable "kinesis_stream_name" {
  description = "Name of the Kinesis stream"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "firehose_s3_bucket" {
  type        = string
  description = "The name of the S3 compressed bucket"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the IAM policy"
  default     = {}
}

variable "firehose_role_name" {
  type        = string
  description = "The name of the IAM role used by Firehose"
}

variable "firehose_s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket where Firehose will store data"
}