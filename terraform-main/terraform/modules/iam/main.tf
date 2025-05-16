resource "aws_iam_policy" "kinesis_access" {
  name        = "kinesis-access-policy"
  description = "Policy for Firehose and EKS pods to access Kinesis"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "kinesis:PutRecord",
          "kinesis:PutRecords",
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListStreams"
        ]
        Resource = "arn:aws:kinesis:${var.region}:${var.aws_account_id}:stream/${var.kinesis_stream_name}"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_kinesis_access" {
  role = var.eks_worker_role_name
  policy_arn = aws_iam_policy.kinesis_access.arn
}

resource "aws_iam_role" "firehose_role" {
  name = var.firehose_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_policy" "firehose_s3_access" {
  name        = "firehose-s3-access-policy"
  description = "Policy for Firehose to access S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ]
        Resource = [
          "arn:aws:s3:::${var.firehose_s3_bucket}",
          "arn:aws:s3:::${var.firehose_s3_bucket}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource   = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "s3.amazonaws.com"
            "kms:EncryptionContext:aws:s3:arn" = "arn:aws:s3:::${var.firehose_s3_bucket}"
          }
        }
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::${var.firehose_s3_bucket}",
        Condition = {
          StringEquals = {
            "s3:prefix": [
              "simulation-data/year=",
              "simulation-data/year=*",
            ]
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "firehose_s3_access" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_s3_access.arn
}

resource "aws_iam_role_policy_attachment" "firehose_kinesis_access" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.kinesis_access.arn
}