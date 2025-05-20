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

variable "vpc_id" {
  description = "VPC ID where Kinesis endpoint will be created"
  type        = string
}

variable "route_table_ids" {
  description = "List of route table IDs associated with the VPC"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}