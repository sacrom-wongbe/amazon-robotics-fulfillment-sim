resource "aws_security_group" "kinesis_endpoint" {
  name        = "kinesis-endpoint-sg"
  description = "Security group for Kinesis VPC Endpoint"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

egress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = [var.vpc_cidr_block]
}

  tags = {
    Name        = "kinesis-endpoint-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "kinesis" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${var.region}.kinesis-streams"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.private_subnets
  security_group_ids = [aws_security_group.kinesis_endpoint.id]

  tags = {
    Name        = "kinesis-vpc-endpoint"
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kinesis_stream" "stream" {
  name             = var.kinesis_stream_name
  shard_count      = var.kinesis_shard_count
  retention_period = 24

  tags = merge(
    {
      Environment = var.environment
      Terraform   = "true"
    },
    var.tags,
  )
}