data "archive_file" "rds_creation_zip" {
  type        = "zip"
  output_path = "${path.module}/rds_creation.zip"
  source_dir  = "${path.module}/rds_creation"
}
