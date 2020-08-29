#!/usr/bin/env bash
rm .terraform -fr
terraform init
terraform validate
make valid
