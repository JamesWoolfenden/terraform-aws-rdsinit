# 'External' Lambda function that gets the new database SNS notification
# and queries the AWS API to obtain further details about this.
#
# It then sends those details off to another SNS notification, which is
# picked up by the 'internal' Lambda function.
resource "aws_lambda_function" "rds_creation" {
  # checkov:skip=CKV_AWS_289: X-Ray tracing not required for this Lambda
  # checkov:skip=CKV_AWS_288: Reserved concurrency not configured for this Lambda
  # checkov:skip=CKV_AWS_284: Log group retention managed separately
  # checkov:skip=CKV_AWS_286: Log group encryption managed separately
  function_name    = "rds-creation"
  handler          = "index.handler"
  filename         = "./rds_creation.zip"
  source_code_hash = data.archive_file.rds_creation_zip.output_base64sha256

  role    = aws_iam_role.rds_external_lambda.arn
  runtime = var.runtime
  timeout = 10

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.internal.arn
    }
  }

  tracing_config {
    mode = "Active"
  }

  tags = var.common_tags
}
