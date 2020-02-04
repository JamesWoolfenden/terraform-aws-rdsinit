variable "subnet_ids" {
  description = "Comma-delimited string of subnet ids"
  type        = list
}

variable "security_group_id" {
  description = "The IDs of security groups"
  type        = string
}

variable "common_tags" {
  description = "To implement the common tags scheme"
  type        = map
  default     = {}
}

variable "db_password_path" {
  description = "The path in parameter store than holds the encrypted db password"
  type        = string
  default     = "/rds/postgres/authentic/password"
}

variable "table_name" {
  type        = string
  description = "The name of the database to create all objects in"
  default     = "authentic"
}