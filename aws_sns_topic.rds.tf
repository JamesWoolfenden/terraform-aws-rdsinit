
# SNS Topic for new database creations (via RDS events)
resource "aws_sns_topic" "rds" {
  name              = "rds-creation"
  kms_master_key_id = "alias/aws/sns"
}
