
# SNS Topic for new database creations (via RDS events)
resource "aws_sns_topic" "rds" {
  name = "rds-creation"
}

# SNS Topic for database credentials (via the external lambda)
resource "aws_sns_topic" "internal" {
  name = "rds-setup"
}

# Subscriptions connecting topics to lambdas
resource "aws_sns_topic_subscription" "rds" {
  topic_arn = aws_sns_topic.rds.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.rds_creation.arn
}


resource "aws_sns_topic_subscription" "rds_internal" {
  topic_arn = aws_sns_topic.internal.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.rds_setup.arn
}