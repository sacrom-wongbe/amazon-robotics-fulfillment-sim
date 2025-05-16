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
  description = "Name of the Firehose bucket"
  type        = string
}

variable "firehose_role_name" {
  description = "Name of the IAM role used by Firehose"
  type        = string
  default     = "firehose-role"
}

variable "eks_worker_role_name" {
  description = "Name of the EKS worker node"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IAM resources"
  type        = map(string)
  default     = {}
}

variable "firehose_log_group_name" {
  description = "CloudWatch Log Group for Firehose"
  type        = string
}