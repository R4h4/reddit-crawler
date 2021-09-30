resource "aws_kinesis_stream" "posts" {
  name        = "${var.app_name}-${var.app_environment}-posts-stream"
  shard_count = 1
}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "${var.app_name}-${var.app_environment}-s3-posts-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.raw.arn

    prefix              = "posts/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    error_output_prefix = "posts/!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/!{firehose:random-string}/"
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.posts.arn
    role_arn = aws_iam_role.firehose_pull_kinesis.arn
  }
}
