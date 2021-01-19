variable "common_tags" {
  description = "To implement the common tags scheme"
  type        = map(any)
  default     = {}
}

variable "db_password_path" {
  description = "The path in the parameter store where your encrypted db password can be retrieved"
  type        = string
  default     = "/rds/postgres/database/password"
}

variable "table_name" {
  type        = string
  description = "The name of the database to create all objects in, probably want to/change supply this"
  default     = "data"
}

variable "sg_tag" {
  description = "The tag to find your security group for your RDS access, you will most likely need to change/supply this value"
  type        = set(string)
  default     = ["RDS"]
}

variable "subnet_tag" {
  description = "A Name tag to find your private subnets, you will most likely need to change/supply this value"
  type        = string
  default     = "*private*"
}

variable "vpc_tag" {
  description = "A Name tag to find your VPC, you will need to supply this value"
  type        = string
  default     = "*Default*"
}

variable "runtime" {
  type    = string
  default = "nodejs12.x"
}

variable "sse_algorithm" {
  default     = "aws:kms"
  type        = string
  description = "(optional) describe your variable"
}

variable "region" {
  type        = string
  description = "AWS region"
}
