

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
  #source_code_hash = filebase64(file("./rds_setup.zip"))

  role    = aws_iam_role.rds_internal_lambda.arn
  runtime = "nodejs12.x"
  timeout = 10

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      PGPASSWORD = var.database_password
      SQL_SCRIPT = replace(trimspace(data.template_file.sql_script.rendered), "/\n/", " ")
    }
  }
}