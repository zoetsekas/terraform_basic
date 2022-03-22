output "sandbox_bucket_id" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.sandbox_bucket.id
}

output "sandbox_bucket_arn" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.sandbox_bucket.arn
}

output "sandbox_bucket_name" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.sandbox_bucket
}