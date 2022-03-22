output "kinesis_arn" {
  description = "arn of the kinesis data stream"
  value       = aws_kinesis_stream.event_stream.arn
}

output "kinesis_name" {
  description = "name of the kinesis data stream"
  value       = aws_kinesis_stream.event_stream.name
}

output "kinesis_id" {
  description = "id of the kinesis data stream"
  value       = aws_kinesis_stream.event_stream.id
}