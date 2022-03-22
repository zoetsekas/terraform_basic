resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM Policy Creation: Allow Cloudwatch Logging

resource "aws_iam_policy" "allow_logging" {
  name        = "allow_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# IAM Policy Creation: Allow Kinesis Processing

resource "aws_iam_policy" "allow_kinesis_processing" {
  name        = "allow_kinesis_processing"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:ListShards",
        "kinesis:ListStreams",
        "kinesis:*"
      ],
      "Resource": "arn:aws:kinesis:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "stream:GetRecord",
        "stream:GetShardIterator",
        "stream:DescribeStream",
        "stream:*"
      ],
      "Resource": "arn:aws:stream:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach IAM Policies to Roles

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_logging.arn
}

resource "aws_iam_role_policy_attachment" "kinesis_processing" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow_kinesis_processing.arn
}


# resource "null_resource" "build_zip" {
#   provisioner "local-exec" {
#     command = "tar.exe. -a -c -f lambda_function.zip C:\\Software\\projects\\vscode\\terraform_basic\\modules\\lambda\\kinesis_receive\\src\\lambda_function.py"
#   }
# }

resource "aws_lambda_function" "receive_kinesis_lambda" {
  filename      = "C:\\Software\\projects\\vscode\\terraform_basic\\modules\\lambda\\kinesis_receive\\lambda_function.zip"
  function_name = "terraform-kinesis-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("C:\\Software\\projects\\vscode\\terraform_basic\\modules\\lambda\\kinesis_receive\\lambda_function.zip")

  runtime = "python3.8"

  environment {
    variables = {
      DATA_STREAM_NAME = var.kinesis_arn
    }
  }
}

resource "aws_lambda_function_event_invoke_config" "example" {
  function_name                = aws_lambda_function.receive_kinesis_lambda.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

# Create Lambda Event Source Mapping

resource "aws_lambda_event_source_mapping" "example" {
  event_source_arn  = var.kinesis_arn
  function_name     = aws_lambda_function.receive_kinesis_lambda.arn
  starting_position = "LATEST"

  depends_on = [
    aws_iam_role_policy_attachment.kinesis_processing
  ]
}