resource "aws_iam_policy" "kinesis_access" {
  name        = "kinesis-access-policy"
  description = "Policy for EKS pods to access Kinesis"
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
          "kinesis:GetRecords"
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