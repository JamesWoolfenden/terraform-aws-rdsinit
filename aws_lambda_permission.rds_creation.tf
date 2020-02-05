resource "aws_lambda_permission" "rds_creation" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_creation.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.rds.arn
}
