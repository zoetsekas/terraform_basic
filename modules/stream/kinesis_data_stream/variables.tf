variable "kinesis_name" {
    description = "The name of the Kinesis Data Stream"
}

variable "stream_mode" {
    description = "The mode of the Kinesis data stream"
    default = "PROVISIONED"
}