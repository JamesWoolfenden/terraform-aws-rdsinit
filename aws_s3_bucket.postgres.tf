resource aws_s3_bucket "postgres" {
    bucket= "postgres-init-${data.aws_caller_identity.current.account_id}"
    acl   = "private"
    tags  = var.common_tags
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.postgres.id
  key    = "postgres/create_user.sql"
  source = var.sql-file
  etag   = filemd5(var.sql-file)
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.postgres.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

variable "sql-file" {
  type    = string
  default = "./sql/create_user.sql"
}

