output "firehose_role_arn" {
  description = "The ARN of the Firehose IAM role"
  value       = aws_iam_role.firehose_role.arn
}

output "kinesis_access_policy_arn" {
  description = "The ARN of the Kinesis access policy"
  value       = aws_iam_policy.kinesis_access.arn
}

output "firehose_s3_access_policy_arn" {
  description = "The ARN of the Firehose S3 access policy"
  value       = aws_iam_policy.firehose_s3_access.arn
}

output "lambda_role_arn" {
  description = "The ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_s3_access_policy_arn" {
  description = "The ARN of the Lambda S3 access policy"
  value       = aws_iam_policy.lambda_s3_access.arn
}
