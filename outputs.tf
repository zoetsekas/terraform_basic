output "landing_data_bucket_arn" {
  description = "ARN of the bucket"
  value       = module.landing_data_bucket.sandbox_bucket_arn
}

output "kinesis_stream_arn" {
  description = "ARN of the bucket"
  value       = module.source_data_stream.kinesis_arn
}