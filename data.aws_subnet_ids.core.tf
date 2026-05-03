data "aws_subnets" "core" {
  filter {
    name   = "vpc-id"
    values = [tolist(data.aws_vpcs.rds.ids)[0]]
  }
  tags = {
    Name = var.subnet_tag
  }
}
