resource "aws_iam_role" "firehose_access_role" {
  count              = local.count
  name               = format("%s-kinesis-stream-role", var.firehose_name)
  assume_role_policy = data.aws_iam_policy_document.firehose_delivery_assume_policy.json
  tags               = var.tags
}


data "aws_iam_policy_document" "firehose_delivery_assume_policy" {
  count = local.count
  statement {
    sid    = "AllowFirehoseToAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "firehose.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      values   = [
        var.aws_account_id]
      variable = "sts:ExternalId"
    }
  }
}

resource "aws_iam_role_policy" "firehose_access_policy" {
  count  = local.count
  name   = "allow_firehose_read_from_kinesis_stream"
  role   = aws_iam_role.firehose_access_role.id
  policy = data.aws_iam_policy_document.read_from_kinesis_stream.json
}

data "aws_iam_policy_document" "read_from_kinesis_stream" {
  count = local.count
  statement {
    sid    = "AllowFirehoseToReadDataFromKinesisStream"
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords"
    ]

    resources = [
      var.kinesis_stream_arn
    ]
  }
}


resource "aws_iam_role" "firehose_delivery_role" {
  count              = local.count
  name               = format("%s-s3-role", var.firehose_name)
  assume_role_policy = data.aws_iam_policy_document.firehose_delivery_assume_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "firehose_delivery_policy" {
  count  = local.count
  name   = "allow_firehose_deliver_to_s3"
  role   = aws_iam_role.firehose_delivery_role.id
  policy = data.aws_iam_policy_document.firehose_delivery_policy_doc.json
}

data "aws_iam_policy_document" "firehose_delivery_policy_doc" {
  count = local.count
  statement {
    sid    = "AllowFirehoseToDeliveryToS3"
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      var.s3_bucket_arn,
      format("%s/*", var.s3_bucket_arn)
    ]
  }

  statement {
    sid    = "AllowFirehoseToSendCloudwatchLog"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowFirehoseToGetGlueTable"
    effect = "Allow"

    actions = [
      "glue:GetTableVersions"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowFirehoseToInvokeKms"
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [
      "*"
    ]
  }
}