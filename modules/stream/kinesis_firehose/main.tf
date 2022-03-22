resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = join("", [var.kinesis_firehose_name, "-", formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())])
  destination = var.firehose_destination

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = var.s3_destination_arn

    # processing_configuration {
    #   enabled = "true"

    #   processors {
    #     type = "Lambda"

    #     parameters {
    #       parameter_name  = "LambdaArn"
    #       parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
    #     }
    #   }
    # }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_input_arn
    role_arn = aws_iam_role.firehose_role.arn
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_nice_cx_role"

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

resource "aws_iam_role_policy_attachment" "read-only-kinesis" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "one-size-fits-all" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose-one-sizes-fits-all.arn
}

resource "aws_iam_policy" "firehose-one-sizes-fits-all" {
  name   = "kinesis-firehose-one-size-fits-all-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": [
                "${var.s3_destination_arn}/",
                "${var.s3_destination_arn}/*"
            ]
        }
    ]
}
EOF
}

# resource "aws_iam_role" "lambda_iam" {
#   name = "lambda_iam"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_lambda_function" "lambda_processor" {
#   filename      = "lambda.zip"
#   function_name = "firehose_lambda_processor"
#   role          = aws_iam_role.lambda_iam.arn
#   handler       = "exports.handler"
#   runtime       = "nodejs12.x"
# }