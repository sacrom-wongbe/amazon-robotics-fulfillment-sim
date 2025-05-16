resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name        = "${var.app_name}-firehose"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_arn
    role_arn           = var.firehose_role_arn
  }

  extended_s3_configuration {
    role_arn           = var.firehose_role_arn
    bucket_arn         = var.firehose_s3_bucket_arn
    buffering_size     = 5
    buffering_interval = 300
    compression_format = "GZIP"
    prefix             = "simulation-data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
  }

  tags = var.tags
}

