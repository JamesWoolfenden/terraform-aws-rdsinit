
# Subscribe to all new database creation notifications 
resource "aws_db_event_subscription" "creation" {
  name             = "rds-creation"
  sns_topic        = aws_sns_topic.rds.arn
  source_type      = "db-instance"
  event_categories = ["creation"]
}
