# terraform-aws-kinesis-firehose

This module provides the ability to create a Kinesis Firehose.

The Kinesis Firehose Stream requires a glue catalog to ensure the records being read off the Kinesis Data Stream are converted to Parquet.

## Examples
### Simple Example to create Kinesis Stream

```
module "kinesis-stream" {
  source                    = "git::https://github.com/bnc-projects/terraform-aws-kinesis-firehose.git?ref=1.0.0"
  kinesis_stream_name       = "var.kinesis_stream_name"
  tags                      = "merge(local.common_tags, var.tags)"
}
```

### Example to create both Kinesis Stream and Kinesis Firehose

```
module "kinesis_stream_and_firehose" {
  source                        = "git::https://github.com/bnc-projects/terraform-aws-kinesis.git?ref=1.5.0"
  kinesis_stream_name           = var.kinesis_stream_name
  shard_count                   = 1
  alarm_actions                 = [var.sns_alarm_arn]
  read_throughput_threshold     = 0.5
  write_throughput_threshold    = 0.3
  create_firehose               = true
  kinesis-firehose_name         = var.firehose_name
  s3_bucket_arn                 = var.s3.arn
  s3_bucket_prefix              = format("%s/", var.s3_bucket_prefix)
  s3_bucket_error_prefix        = format("%s-err/", var.s3_bucket_prefix)
  firehose_alarm_period         = 960
  aws_account_id                = var.aws_account_id
  data_format_conversion_enable = true
  data_format_conversion_schema = {
    database_name = var.catalog_database
    table_name    = var.catalog_table
    region        = var.aws_default_region
  }
  tags                          = merge(local.common_tags, var.tags)
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| kinesis_stream_name | A name to identify the kinesis stream | string | - | yes |
| shard_count | The number of shards that the stream will use | number | `1` | no |
| retention_period | Length of time data records are accessible after they are added to the stream | number | `24` | no |
| shard_level_metrics | A list of shard-level CloudWatch metrics which can be enabled for the stream | list | - | no |
| encryption_type | The encryption type to use | string | `KMS` | no |
| kms_key_id | he GUID for the customer-managed KMS key to use for encryption| string | `alias/aws/kinesis` | no |
| alarm_actions | Actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN) | list | `[]` | no |
| read_throughput_evaluation_periods | The number of periods over which data is compared to the specified threshold.| number | `1` | no |
| read_throughput_period | The period in seconds over which the specified statistic is applied | number | `60` | no |
| read_throughput_statistic | The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum| string | `Average` | no |
| read_throughput_threshold | The value against which the specified statistic is compared | number | `0` | no |
| write_throughput_evaluation_periods | The number of periods over which data is compared to the specified threshold | number | `1` | no |
| write_throughput_period | The period in seconds over which the specified statistic is applied.| number | `60` | no |
| write_throughput_statistic | The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum| string | `Average` | no |
| write_throughput_threshold | The value against which the specified statistic is compared | number | `0` | no |
| create_firehose | Indicate whether to create a kinesis firehose | bool | `false` | no |
| kinesis-firehose_name | A name to identify the kinesis firehose | string | `false` | no |
| s3_bucket_arn | A name to identify s3 bucket to store kinesis firehose loading data| string | `""` | no |
| s3_bucket_prefix | The s3 bucket folder to store the data which is being converted to Parquet | string | `""` | no |
| s3_bucket_error_prefix | The s3 bucket folder to store the data if there are errors with conversion to Parquet | string | `""` | no |
| s3_bucket_backup_prefix | The name of the folder to store the source data | string | `""` | no |
| buffer_size | Buffer incoming data to the specified size, in MBs, before delivering it to the destination | number | `128` | no |
| buffer_interval | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination | number | `900` | no |
| compression_format | The compression format| string | `SNAPPY` | no |
| cloudwatch_log_enable | Indicate whether to create cloudwatch log for kinesis firehose | bool | `true` | no |
| data_format_conversion_enable | Check if the data conversion is enabled | bool | `false` | no |
| enable_s3_backup | Enable backup of the source data | string | `Enabled` | no |
| firehose_alarm_evaluation_periods |  The number of periods over which data is compared to the specified threshold | number | `1` | no |
| firehose_alarm_threshold | The value against which the specified statistic is compared | number | `0` | no |
| firehose_alarm_period | The period in seconds over which the specified statistic is applied | number | `960` | no |
| firehose_alarm_statistic | The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum | string | `Sum` | no |
| data_format_conversion_schema | The schema configuration of glue table | map | `map` | no |
| aws_account_id | The aws account id that creates resources | string | `""` | no |
| tags | A map of tags to add to the appropriate resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| kinesis_firehose_arn  | The Amazon Resource Name (ARN) specifying the Kinesis Firehose |
| kinesis_firehose_name | The unique Kinesis Firehose Name |
