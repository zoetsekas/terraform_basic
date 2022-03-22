variable "function_name" {
    default = "S3_Notifier"
}

variable "handler_name" {
    default = "lambda_function"
}

variable "runtime" {
    default = "python3.6"
}

variable "timeout" {
    default = "900"
}

variable "business_kinesis" {
    default = "business_kinesis_arn"
}

variable "operational_kinesis" {
    default = "operational_kinesis_arn"
}

variable "lambda_role_name" {
    default = "s3_notifer_lambda_iam_role"
}

variable "lambda_iam_policy_name" {
    default = "s3_notifer_lambda_iam_policy"
}

variable "bucket_name" {
    default = "landing_bucket_name"
}

variable "bucket_id" {
    default = "landing_bucket_id"
}


