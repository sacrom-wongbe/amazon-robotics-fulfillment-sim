output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.gz_to_csv_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.gz_to_csv_lambda.arn
}