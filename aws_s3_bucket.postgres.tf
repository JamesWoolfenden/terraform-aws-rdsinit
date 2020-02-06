resource aws_s3_bucket "postgres" {
  bucket = "postgres-init-${data.aws_caller_identity.current.account_id}"

  versioning {
    enabled = true
  }

  acl  = "private"
  tags = var.common_tags
}

resource "aws_s3_bucket_object" "stuff" {
  for_each = fileset(path.module, "postgres/**")
  bucket   = aws_s3_bucket.postgres.bucket
  key      = each.value
  source   = "${path.module}/${each.value}"
  etag     = filemd5("${path.module}/${each.value}")
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.postgres.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
