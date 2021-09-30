
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.app_name}-${var.app_environment}-firehose-raw-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "put_s3_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.raw.arn, "${aws_s3_bucket.raw.arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "put_s3" {
  policy = data.aws_iam_policy_document.put_s3_policy.json
  role = aws_iam_role.firehose_role.id
}

resource "aws_iam_role" "task_role" {
  name = "${var.app_name}-${var.app_environment}-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "task_role_policy" {
  statement {
    effect  = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [
      aws_kinesis_stream.posts.arn
    ]
  }
  statement {
    effect  = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [aws_cloudwatch_log_group.log-group.arn]
  }
}

resource "aws_iam_role_policy" "put_kinesis" {
  policy = data.aws_iam_policy_document.task_role_policy.json
  role = aws_iam_role.task_role.id
}

resource "aws_iam_role" "firehose_pull_kinesis" {
  name = "${var.app_name}-${var.app_environment}-firehose-pull-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "pull_from_kinesis" {
  statement {
    effect  = "Allow"
    actions = [
      "kinesis:*"
    ]
    resources = [aws_kinesis_stream.posts.arn]
  }
}

resource "aws_iam_role_policy" "pull_kinesis" {
  policy = data.aws_iam_policy_document.pull_from_kinesis.json
  role = aws_iam_role.firehose_pull_kinesis.id
}