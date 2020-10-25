# SNS Topic for database credentials (via the external lambda)
resource "aws_sns_topic" "internal" {
  name              = "rds-setup"
  kms_master_key_id = "alias/aws/sns"
  tags              = var.common_tags
}
