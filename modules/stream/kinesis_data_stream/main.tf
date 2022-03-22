resource "aws_kinesis_stream" "event_stream" {
  name             = join("", [var.kinesis_name, "-", formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())])
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = var.stream_mode
  }

  tags = {
    environment = "sandbox"
  }
}


resource "aws_iam_policy" "read-only" {
  count = 1

  name        = join("", [var.kinesis_name, "-", formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())])
  path        = "/"
  description = "Managed by Terraform"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat([
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeLimits",
          "kinesis:DescribeStream",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:SubscribeToShard",
          "kinesis:ListShards"
        ]
        Resource = [
          aws_kinesis_stream.event_stream.arn
        ]
      }
    ])
  })
}