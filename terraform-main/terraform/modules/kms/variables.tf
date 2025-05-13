variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "app_name" {
  description = "Name of the application/cluster"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Additional tags for KMS key"
  type        = map(string)
  default     = {}
}

variable "key_service_roles_for_autoscaling" {
  description = "List of IAM roles that can use the KMS key for autoscaling"
  type        = list(string)
  default = [
    "arn:aws:iam::ACCOUNT_ID:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  ]
}