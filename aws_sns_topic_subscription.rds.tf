# Subscriptions connecting topics to lambdas
resource "aws_sns_topic_subscription" "rds" {
  topic_arn = aws_sns_topic.rds.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.rds_creation.arn
}
