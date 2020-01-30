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

variable "sql-file" {
  type    = string
  default = "./sql/create_user.sql"
}

