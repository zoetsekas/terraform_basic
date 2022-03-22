
module "landing_data_bucket" {
  source = "./modules/bucket"

  bucket_name = var.bucket_name

  logging_prefix = "data/raw"
}

module "source_data_stream" {
  source = "./modules/stream/kinesis_data_stream"

  kinesis_name = "source_data_stream"
}

module "business_data_stream" {
  source = "./modules/stream/kinesis_data_stream"

  kinesis_name = "business_data_stream"
}

module "operational_data_stream" {
  source = "./modules/stream/kinesis_data_stream"

  kinesis_name = "operational_data_stream"
}

module "lambda_receive" {
  source = "./modules/lambda/kinesis_receive"

  kinesis_arn = module.source_data_stream.kinesis_arn
}

module "lambda_s3_to_kinesis" {
  source = "./modules/lambda/s3_trigger"

  business_kinesis = module.business_data_stream.kinesis_name
  operational_kinesis = module.operational_data_stream.kinesis_name
  bucket_id = module.landing_data_bucket.sandbox_bucket_id
  bucket_name = module.landing_data_bucket.sandbox_bucket_name
}

module "firehose_stream" {
  source = "./modules/stream/kinesis_firehose"

  kinesis_firehose_name = "firehose"

  s3_destination_arn = module.landing_data_bucket.sandbox_bucket_arn

  kinesis_input_arn = module.source_data_stream.kinesis_arn

  # depends_on = [
  #   module.landing_data_bucket,
  #   module.source_data_stream
  # ]
}







