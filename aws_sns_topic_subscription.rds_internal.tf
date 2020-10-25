resource "aws_sns_topic_subscription" "rds_internal" {
  topic_arn = aws_sns_topic.internal.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.rds_setup.arn
  tags      = var.common_tags
}
