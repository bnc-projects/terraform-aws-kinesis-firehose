variable "kinesis-firehose_name" {
  type        = string
  description = "The name of kinesis firehose"
  default     = ""
}

variable "s3_bucket_arn" {
  type        = string
  description = "The ARN of the S3 bucket"
  default     = ""
}

variable "s3_bucket_prefix" {
  type        = string
  description = "The name of the folder to store data"
  default     = ""
}

variable "s3_bucket_error_prefix" {
  type        = string
  description = "The name of the folder to store error data"
  default     = ""
}

variable "s3_bucket_backup_prefix" {
  type        = string
  description = "The name of the folder to store the source data"
  default     = ""
}

variable "enable_s3_backup" {
  type        = string
  description = "Enable backup of the source data"
  default     = "Enabled"
}

variable "buffer_size" {
  type        = number
  description = "Buffer incoming data to the specified size, in MBs, before delivering it to the destination"
  default     = 128
}

variable "buffer_interval" {
  type        = number
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination"
  default     = 900
}

variable "compression_format" {
  type        = string
  description = "The compression format"
  default     = "Snappy"
}

variable "cloudwatch_log_enable" {
  type        = bool
  description = "Check if the cloudwatch log is enabled"
  default     = true
}

variable "data_format_conversion_enable" {
  type        = bool
  description = "Check if the data conversion is enabled"
  default     = false
}

variable "firehose_alarm_evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold."
  default     = 1
}

variable "firehose_alarm_threshold" {
  type        = number
  description = "The value against which the specified statistic is compared."
  default     = 0
}

variable "firehose_alarm_period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied."
  default     = 300
}

variable "firehose_alarm_statistic" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Sum"
}

variable "data_format_conversion_schema" {
  type        = map(string)
  description = "The schema configuration of glue table"
  default     = {
    database_name = ""
    table_name    = ""
    region        = ""
  }
}

variable "aws_account_id" {
  type        = string
  description = "The aws account id that creates resources"
  default     = ""
}

variable "alarm_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}
