#!/usr/bin/env bash
rm .terraform.lock.hcl
rm .terraform -fr
terraform init -upgrade
terraform validate
terraform fmt
