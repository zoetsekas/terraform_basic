variable "kinesis_firehose_name" {
    description = "The name of the Kinesis Firehose"
}

variable "firehose_destination" {
    description = "The name of the bucket to be used as destination"
    default = "extended_s3"
}

variable "s3_destination_arn" {
    description = "The arn of the bucket to be used as destination"
}

variable "kinesis_input_arn" {
    description = "The arn of the kinesis stream to be used as input"
}