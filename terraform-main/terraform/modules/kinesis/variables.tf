variable "vpc_id" {
  description = "VPC ID where Kinesis endpoint will be created"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "kinesis_stream_name" {
  description = "Name of the Kinesis stream"
  type        = string
}

variable "eks_worker_role_name" {
  description = "IAM role name for EKS worker nodes"
  type        = string
}

variable "kinesis_shard_count" {
  description = "Number of shards for the Kinesis stream"
  type        = number
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS key ARN for Kinesis stream encryption"
  type        = string
}
