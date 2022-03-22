variable "bucket_name" {
  default = "zoe-aws-sandbox"
}

variable "log_bucket_name" {
  default = "zoe-aws-sandbox-log"
}

variable "acl_value" {
  description = "the default AWS S3 bucket ACL"
  default     = "private"
}

variable "logging" {
  type=map
  default={
      target_bucket = ""
      target_prefix = ""
  }
}

variable "logging_prefix" {
  description = "the prefix of objects for logging bucket"
}


