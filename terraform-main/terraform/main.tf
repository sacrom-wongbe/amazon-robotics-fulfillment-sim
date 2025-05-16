terraform {
  backend "s3" {
    bucket = "805791260265-bucket-state-file"
    key    = "terraform.eks.tfstate"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "vpc" {
  source      = "./modules/vpc"
  region      = var.region
  environment = var.environment
  azs         = var.azs
}

module "kms" {
  source      = "./modules/kms"
  region      = var.region
  environment = var.environment
  app_name    = var.app_name
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "iam" {
  source = "./modules/iam"

  eks_worker_role_name = module.eks.worker_iam_role_name
  kinesis_stream_name = var.kinesis_stream_name
  firehose_s3_bucket     = module.s3.archive_bucket_name
  firehose_role_name = var.firehose_role_name
  region = var.region
  firehose_log_group_name = var.firehose_log_group_name
  aws_account_id = data.aws_caller_identity.current.account_id
  tags              = var.tags
}

module "eks" {
  source      = "./modules/eks"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets
  region      = var.region
  environment = var.environment
  app_name    = var.app_name
  kms_key_arn = module.kms.key_arn
  eks_version = var.eks_version
  node_instance_type = var.node_instance_type
  desired_capacity = var.desired_capacity
  max_capacity = var.max_capacity
  min_capacity = var.min_capacity
  tags = var.tags
}

module "kinesis" {
  source             = "./modules/kinesis"
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  region             = var.region
  environment        = var.environment
  kinesis_stream_name = var.kinesis_stream_name
  eks_worker_role_name = module.eks.worker_iam_role_name
  kinesis_shard_count = var.kinesis_shard_count
  kms_key_arn = module.kms.key_arn
  tags = var.tags
  vpc_cidr_block = module.vpc.vpc_cidr_block
}

module "ecr" {
  source      = "./modules/ecr"
  region      = var.region
  environment = var.environment
  app_name    = var.app_name
  kms_key_arn = module.kms.key_arn
  tags = var.tags
}

module "firehose" {
  source      = "./modules/firehose"
  region      = var.region
  environment = var.environment
  app_name    = var.app_name
  kinesis_stream_arn = module.kinesis.kinesis_stream_arn
  firehose_s3_bucket = var.firehose_s3_bucket
  firehose_s3_bucket_arn = module.s3.archive_bucket_arn
  firehose_role_arn  = module.iam.firehose_role_arn
  firehose_log_group_name = var.firehose_log_group_name
  firehose_log_stream_name = var.firehose_log_stream_name
  tags = var.tags
}

module "s3" {
  source      = "./modules/s3"
  app_name    = var.app_name
  environment = var.environment
  archive_bucket_name = var.firehose_s3_bucket
  processed_bucket_name = var.processed_s3_bucket
}