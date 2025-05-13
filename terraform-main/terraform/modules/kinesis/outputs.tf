output "kinesis_endpoint_id" {
  description = "ID of the Kinesis VPC endpoint"
  value       = aws_vpc_endpoint.kinesis.id
}

output "kinesis_endpoint_dns" {
  description = "DNS entries of Kinesis VPC endpoint"
  value       = aws_vpc_endpoint.kinesis.dns_entry
}

output "security_group_id" {
  description = "Security group ID for Kinesis endpoint"
  value       = aws_security_group.kinesis_endpoint.id
}

output "kinesis_policy_arn" {
  description = "ARN of the Kinesis access IAM policy"
  value       = aws_iam_policy.kinesis_access.arn
}