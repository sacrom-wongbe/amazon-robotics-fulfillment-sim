module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"
  cluster_name    = var.app_name
  cluster_version = var.eks_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids

  eks_managed_node_group_defaults = {
    instance_types = [var.node_instance_type]
  }

  eks_managed_node_groups = {
    "${var.app_name}-workers" = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"

      min_size     = var.min_capacity
      max_size     = var.max_capacity
      desired_size = var.desired_capacity

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 20
            volume_type = "gp3"
            iops = 1000
            throughput = 125
            encrypted = true
            kms_key_id = var.kms_key_arn
            delete_on_termination = true
          }
        }
      }

      labels = {
        Environment = var.environment
        NodeType    = "worker"
      }
    }
  }

  enable_cluster_creator_admin_permissions = true

  create_kms_key = false
  cluster_encryption_config = {
    resources = ["secrets"]
    provider_key_arn = var.kms_key_arn
  }

  tags = merge(
    {
      Environment = var.environment
      Terraform   = "true"
    },
    var.tags,
  )
}

data "aws_caller_identity" "current" {}