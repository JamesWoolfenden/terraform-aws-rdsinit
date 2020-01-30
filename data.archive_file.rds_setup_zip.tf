data "archive_file" "rds_setup_zip" {
  type        = "zip"
  output_path = "${path.module}/rds_setup.zip"
  source_dir  = "${path.module}/rds_setup"
}

