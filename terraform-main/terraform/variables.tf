variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "eks-cluster"
}

variable "kinesis_stream_name" {
  description = "Name of the Kinesis stream"
  type        = string
  default     = "robotics-sim-stream"
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.small"
}

variable "firehose_s3_bucket" {
  description = "Name of the initial S3 bucket"
  type        = string
  default     = "compressed-archive-bucket"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "kinesis_shard_count" {
  description = "Number of shards for the Kinesis stream"
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "processed_s3_bucket" {
  description = "Name of the processed S3 bucket for CSV data"
  type        = string
  default     = "processed-analytics-csv-bucket"
}

variable "firehose_role_name" {
  description = "Name of the IAM role used by Firehose"
  type        = string
  default     = "firehose-role"
}

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
}

variable "firehose_log_group_name" {
  description = "CloudWatch Log Group for Firehose"
  type        = string
  default     = "firehose-log-group"
}

variable "firehose_log_stream_name" {
  description = "CloudWatch Log Stream for Firehose"
  type        = string
  default     = "firehose-log-stream"
}

variable "lambda_runtime" {
  type = string
  default = "python3.9"
  description = "Runtime for the Lambda function"
}

variable "gz_to_csv_source_code_path" {
  type        = string
  default     = "C:/Users/bened/amazon-robotics-fulfillment-sim/terraform-main/terraform/modules/lambda/functions/gzToCSV_lambda_function.zip"
  description = "Path to the zipped Lambda function code"
}

variable "gz_to_csv__timeout" {
  type = number
  default = 30
  description = "Timeout for the Lambda function"
}

variable "gz_to_csv__memory_size" {
  type = number
  default = 256
  description = "Memory size for the Lambda function"
}

variable "gz_to_csv_handler" {
  description = "Handler for the gzToCSV Lambda function"
  type        = string
  default     = "gzToCSV_lambda_function.lambda_handler"
}
