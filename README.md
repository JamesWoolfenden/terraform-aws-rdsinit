# terraform-aws-rdsinit

[![Build Status](https://github.com/JamesWoolfenden/terraform-aws-rdsinit/workflows/Verify%20and%20Bump/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-aws-rdsinit)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-aws-rdsinit.svg)](https://github.com/JamesWoolfenden/terraform-aws-rdsinit/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-aws-rdsinit.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-aws-rdsinit/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.14.0-blue.svg)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/JamesWoolfenden/terraform-aws-rdsinit/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=JamesWoolfenden%2Fterraform-aws-rdsinit&benchmark=CIS+AWS+V1.2)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![checkov](https://img.shields.io/badge/checkov-verified-brightgreen)](https://www.checkov.io/)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/jameswoolfenden/terraform-aws-rdsinit/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=JamesWoolfenden%2Fterraform-aws-rdsinit&benchmark=INFRASTRUCTURE+SECURITY)

After https://gist.github.com/pat/7b61376981b40cfdbb1166734b8d184f

## Automatic RDS initiator

This Terraform configuration allows running of a set of SQL commands on a new AWS RDS database instance that's operating within an AWS VPC.

The commands are executed via AWS Lambda functions - the first (`rds_creation`) operates outside the VPC and connects to the AWS API to determine credential information for the new database (endpoint, port, username, database). It then sends these details via SNS to another function operating _within_ the VPC (`rds_setup`), which connects to the Postgres database and executes the SQL commands.

The initial notification comes via SNS from the RDS events (and there is the configuration within the Terraform file here to set up that subscription).

Please note:

- There are variables with defaults defined - everything else should be pretty self-contained.automatic (though you should definitely read through all of the code to ensure you understand it before using it).
- The internal Lambda function is expecting a Postgres database. This will need changing if you're going to use MySQL/Aurora/etc.
- The internal Lambda function connects via SSL, and so requires a local copy of the [AWS SSL Certificate file](https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem) (which I have saved as `rds-cert.pem` within the `rds_setup` directory).

```cli
curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o ./rds_setup/rds-cert.pem
```

- Build the lambdas

Each lambda function is stored within their respective folders (`rds_creation`, `rds_setup`), with their `package.json` for NPM to build.

Building:

```cli
npm install
```

These folders are automatically archived/zipped by Terraform.

This template uses:

- Cloudwatch
- S3
- Lambda
- SNS
- IAM
- aws-sdk
- SPS
- node

## Usage

Set tags to allow tf to find VPC, Subnets and Security groups. Expects a Subnet called RDS to exist.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.24.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.0.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.24.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_event_subscription.creation](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/db_event_subscription) | resource |
| [aws_iam_role.rds_external_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/iam_role) | resource |
| [aws_iam_role.rds_internal_lambda](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.rds_dump](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.rds_external](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.rds_internal](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.rds_sps](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.rds_lambda_vpc](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.rds_creation](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/lambda_function) | resource |
| [aws_lambda_function.rds_setup](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.rds_creation](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.rds_setup](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.postgres](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.stuff](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_public_access_block.access](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_sns_topic.internal](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/sns_topic) | resource |
| [aws_sns_topic.rds](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.rds](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.rds_internal](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/sns_topic_subscription) | resource |
| [archive_file.rds_creation_zip](https://registry.terraform.io/providers/hashicorp/archive/2.0.0/docs/data-sources/file) | data source |
| [archive_file.rds_setup_zip](https://registry.terraform.io/providers/hashicorp/archive/2.0.0/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/data-sources/region) | data source |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.core](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/data-sources/subnet_ids) | data source |
| [aws_vpcs.rds](https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/data-sources/vpcs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | To implement the common tags scheme | `map(any)` | `{}` | no |
| <a name="input_db_password_path"></a> [db\_password\_path](#input\_db\_password\_path) | The path in the parameter store where your encrypted db password can be retrieved | `string` | `"/rds/postgres/database/password"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | n/a | `string` | `"nodejs12.x"` | no |
| <a name="input_sg_tag"></a> [sg\_tag](#input\_sg\_tag) | The tag to find your security group for your RDS access, you will most likely need to change/supply this value | `set(string)` | <pre>[<br>  "RDS"<br>]</pre> | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | (optional) describe your variable | `string` | `"aws:kms"` | no |
| <a name="input_subnet_tag"></a> [subnet\_tag](#input\_subnet\_tag) | A Name tag to find your private subnets, you will most likely need to change/supply this value | `string` | `"*private*"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | The name of the database to create all objects in, probably want to/change supply this | `string` | `"data"` | no |
| <a name="input_vpc_tag"></a> [vpc\_tag](#input\_vpc\_tag) | A Name tag to find your VPC, you will need to supply this value | `string` | `"*Default*"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Replace **invoke.sql** with your own database script.

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-aws-rdsinit/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/terraform-aws-rdsinit/issues) to report any bugs or file feature requests.

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage] <br>[![pat][pat_avatar]][pat_homepage]<br>[![michele][michele_avatar]][michele_homepage]

[James Woolfenden][jameswoolfenden_homepage] <br> [Pat Allen][pat_homepage] <br> [michele][michele_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
[pat_homepage]: https://github.com/pat
[pat_avatar]: https://github.com/pat.png?size=150
[michele_homepage]: https://github.com/miki79
[michele_avatar]: https://github.com/miki79.png?size=150
[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
[michele_homepage]: https://github.com/miki79
[michele_avatar]: https://github.com/miki79.png?size=150
[linkedin]: https://www.linkedin.com/in/jameswoolfenden/
[twitter]: https://twitter.com/JimWoolfenden
[share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-rdsinit&url=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-rdsinit&url=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_reddit]: https://reddit.com/submit/?url=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_email]: mailto:?subject=terraform-aws-rdsinit&body=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
