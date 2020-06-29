# 'Internal' Lambda function which receives database information from
# the external function (via SNS) and then connects to the database
# and evaluates the script against it.
#
# This operates within the VPC, and hence does not have access to the
# internet or AWS APIs.
resource "aws_lambda_function" "rds_setup" {
  function_name    = "rds-setup"
  handler          = "index.handler"
  filename         = "./rds_setup.zip"
  source_code_hash = data.archive_file.rds_setup_zip.output_base64sha256

  role        = aws_iam_role.rds_internal_lambda.arn
  runtime     = var.runtime
  timeout     = 120
  memory_size = 512

  vpc_config {
    subnet_ids         = tolist(data.aws_subnet_ids.core.ids)
    security_group_ids = [data.aws_security_group.rds.id]
  }

  environment {
    variables = {
      BUCKET             = aws_s3_bucket.postgres.id
      DB_PASSWORD_PATH   = var.db_password_path
      QUERY_COMMANDS_KEY = tolist(fileset(path.module, "postgres/*.sql"))[0]
      TABLE_NAME         = var.table_name
      RDS_CERT_KEY       = tolist(fileset(path.module, "postgres/*.pem"))[0]
      REGION             = data.aws_region.current.name
    }
  }

  tracing_config {
    mode = "Active"
  }

  tags = var.common_tags
}
