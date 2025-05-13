data "aws_caller_identity" "current" {}

resource "aws_iam_role" "autoscaling_role" {
  name = "AWSServiceRoleForAutoScaling_custom"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "autoscaling.amazonaws.com"
        },
        Effect = "Allow",
        Sid   = ""
      }
    ]
  })
  path             = "/aws-service-role/autoscaling.amazonaws.com/"
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.1"

  description = "EKS cluster KMS key"
  key_usage   = "ENCRYPT_DECRYPT"

  key_administrators = [data.aws_caller_identity.current.arn] # Consider using specific IAM role ARNs
  key_service_roles_for_autoscaling = [aws_iam_role.autoscaling_role.arn]
  key_owners = [data.aws_caller_identity.current.arn] # Consider using specific IAM role ARNs

  aliases = ["eks/${var.app_name}"]

  tags = merge(
    {
      Terraform   = "true"
      Environment = var.environment
    },
    var.tags,
  )
}