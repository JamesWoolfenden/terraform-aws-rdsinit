variable "database_password" {
  type = string
}

variable "subnet_ids" {
  description = "Comma-delimited string of subnet ids"
  type        = list
}

variable "security_group_id" {
  type = string
}

variable "common_tags" {
  type=map
  default={}
}
