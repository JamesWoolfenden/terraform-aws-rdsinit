#!/usr/bin/env pwsh
$ErrorActionPreference ="Stop"
Remove-Item .terraform -Recurse -ErrorAction SilentlyContinue
Remove-Item .terraform.lock.hcl -ErrorAction SilentlyContinue
terraform init -upgrade
terraform validate
terraform fmt
