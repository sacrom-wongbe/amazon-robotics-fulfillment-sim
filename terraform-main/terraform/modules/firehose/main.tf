resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name        = "${var.app_name}-firehose"
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_arn
    role_arn           = var.firehose_role_arn
  }

  s3_configuration {
    role_arn           = var.firehose_role_arn
    bucket_arn         = var.firehose_s3_bucket
    buffer_size        = 5
    buffer_interval    = 300
    compression_format = "GZIP"
  }

  tags = var.tags
}