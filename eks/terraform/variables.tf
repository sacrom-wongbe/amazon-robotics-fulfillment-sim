# Variables for environment
variable "region" {
  type    = string
  default = "us-west-2"
}

variable "aws_account_id" {
  type    = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "eks-cluster"
}