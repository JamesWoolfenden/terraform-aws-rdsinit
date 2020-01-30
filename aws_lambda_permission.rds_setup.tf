resource "aws_lambda_permission" "rds_setup" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_setup.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.internal.arn
}