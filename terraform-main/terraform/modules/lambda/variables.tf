variable "runtime" {
  description = "Runtime for the Lambda function (e.g., python3.9, nodejs14.x)"
  type        = string
}

variable "gz_to_csv_handler" {
  description = "Handler for the gzToCSV Lambda function"
  type        = string
  default     = "gzToCSV_lambda_function.lambda_handler"
}

variable "gz_to_csv_source_code_path" {
  type        = string
  description = "Path to the zipped Lambda function code for gzToCSV"
}

variable "gz_to_csv_environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "gz_to_csv_timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
  default     = 15
}

variable "gz_to_csv_memory_size" {
  description = "Memory size for the Lambda function in MB"
  type        = number
  default     = 128
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs the Lambda function can access"
  type        = list(string)
  default     = []
}

variable "invocation_principal" {
  description = "Principal allowed to invoke the Lambda function (e.g., API Gateway)"
  type        = string
  default     = "apigateway.amazonaws.com"
}

variable "lambda_role_arn" {
  description = "The ARN of the Lambda IAM role"
  type       = string
}