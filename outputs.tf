output "kinesis_firehose_arn" {
  value = var.kinesis_stream_as_source == false ? aws_kinesis_firehose_delivery_stream.extended_s3_stream_direct_put[0].arn : aws_kinesis_firehose_delivery_stream.extended_s3_stream_kinesis_source[0].arn
}

output "kinesis_firehose_name" {
  value = var.kinesis_stream_as_source == false ? aws_kinesis_firehose_delivery_stream.extended_s3_stream_direct_put[0].name : aws_kinesis_firehose_delivery_stream.extended_s3_stream_kinesis_source[0].name
}