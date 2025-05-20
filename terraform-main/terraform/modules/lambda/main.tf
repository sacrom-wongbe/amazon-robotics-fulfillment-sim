resource "aws_lambda_function" "gz_to_csv_lambda" {
  function_name = "gzToCSV-function"
  runtime       = var.runtime
  handler       = var.gz_to_csv_handler  # Specific handler for this function
  role          = var.lambda_role_arn
  filename      = var.gz_to_csv_source_code_path

  environment {
    variables = var.gz_to_csv_environment_variables
  }

  timeout      = var.gz_to_csv_timeout
  memory_size  = var.gz_to_csv_memory_size

  tags = var.tags
}

resource "aws_lambda_permission" "eventbridge_invoke_gz_to_csv_lambda" {
  statement_id  = "AllowEventBridgeInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gz_to_csv_lambda.function_name
  principal     = "events.amazonaws.com"
}