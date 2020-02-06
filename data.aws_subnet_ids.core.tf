data "aws_subnet_ids" "core" {
  vpc_id = tolist(data.aws_vpcs.rds.ids)[0]
  tags = {
    Name = var.subnet_tag
  }
}
