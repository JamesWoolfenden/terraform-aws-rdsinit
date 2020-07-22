#!/usr/bin/env pwsh

Remove-Item .terraform -force -Recurse -ErrorAction SilentlyContinue
terraform init
terraform validate
