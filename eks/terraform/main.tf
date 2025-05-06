#########################################################
# Provider
#########################################################
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

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
#########################################################
# Data
#########################################################
data "aws_caller_identity" "current" {}


#########################################################
# VPC
#########################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  
  name = "eks-cluster-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  intra_subnets   = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  tags = {
    Terraform = "true"
    Environment = var.environment
  }
}

#########################################################
# KMS
#########################################################

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.1"

  description = "EKS cluster"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy
  key_administrators                 = [data.aws_caller_identity.current.arn]
  key_service_roles_for_autoscaling  = ["arn:aws:iam::${var.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  key_owners         = [data.aws_caller_identity.current.arn]
  
  # Aliases
  aliases = ["eks/${var.app_name}"]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

#########################################################
# EKS
#########################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"
  cluster_name    = var.app_name
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }



  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small"]
  }

  eks_managed_node_groups = {
    "${var.app_name}-ng" = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 10
      desired_size = 3

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 20
            volume_type = "gp3"
            iops = 3000
            throughput = 125
            encrypted = true
            kms_key_id = module.kms.key_arn
            delete_on_termination = true
          }
        }
      }
    }
  }

  enable_cluster_creator_admin_permissions = true


  access_entries = {
    terraform_admin = {
      principal_arn = "arn:aws:iam::805791260265:user/terraform"
      username      = "terraform-admin"
      
      policy_associations = {
        admin_access = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type        = "cluster"
          }
        }
      }
    }
  }


  create_kms_key = false
  cluster_encryption_config = {
    resources = ["secrets"]
    provider_key_arn = module.kms.key_arn
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
