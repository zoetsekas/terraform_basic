resource "aws_iam_role" "lambda_iam" {
  name = var.lambda_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "revoke_keys_role_policy" {
  name = var.lambda_iam_policy_name
  role = aws_iam_role.lambda_iam.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "ses:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_iam.arn
  handler          = "src/${var.handler_name}.lambda_handler"
  runtime          = var.runtime
  timeout          = var.timeout
  filename         = "C:\\Software\\projects\\vscode\\terraform_basic\\modules\\lambda\\s3_trigger\\lambda_function.zip"
  source_code_hash = filebase64sha256("C:\\Software\\projects\\vscode\\terraform_basic\\modules\\lambda\\s3_trigger\\lambda_function.zip")
  environment {
    variables = {
      business_stream   = var.business_kinesis
      operational_stream = var.operational_kinesis
    }
  }
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = var.bucket_id
  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]

  }
}
resource "aws_lambda_permission" "s3-lambda-permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_id}"
}