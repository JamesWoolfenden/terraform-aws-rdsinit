terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.24.1`"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
  required_version = ">= 0.13"
}
