# terraform-aws-rdsinit

[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-aws-rdsinit.svg)](https://github.com/JamesWoolfenden/terraform-aws-rdsinit/releases/latest)

After https://gist.github.com/pat/7b61376981b40cfdbb1166734b8d184f

## Automatic RDS initiator

This Terraform configuration allows running of a set of SQL commands on a new AWS RDS database instance that's operating within an AWS VPC.

The commands are executed via AWS Lambda functions - the first (`rds_creation`) operates outside the VPC and connects to the AWS API to determine credential information for the new database (endpoint, port, username, database). It then sends these details via SNS to another function operating _within_ the VPC (`rds_setup`), which connects to the Postgres database and executes the SQL commands.

The initial notification comes via SNS from the RDS events (and there is the configuration within the Terraform file here to set up that subscription).

Please note:

* There are variables with defaults defined - everything else should be pretty self-contained.automatic (though you should definitely read through all of the code to ensure you understand it before using it).
* The internal Lambda function is expecting a Postgres database. This will need changing if you're going to use MySQL/Aurora/etc.
* The internal Lambda function connects via SSL, and so requires a local copy of the [AWS SSL Certificate file](https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem) (which I have saved as `rds-cert.pem` within the `rds_setup` directory).

```cli
curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o ./rds_setup/rds-cert.pem
```

* Build the lambdas

Each lambda function is stored within their respective folders (`rds_creation`, `rds_setup`), with their `package.json` for NPM to build.

Building:

```cli
npm install
```

These folders are automatically archived/zipped by Terraform.

This template uses:

* Cloudwatch
* S3
* Lambda
* SNS
* IAM
* aws-sdk
* SPS
* node

## Usage

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Error: no lines in file
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
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage] <br>[![pat][pat_avatar]][pat_homepage]<br>[![michele][michele_avatar]][michele_homepage]

[James Woolfenden][jameswoolfenden_homepage] <br> [Pat Allen][pat_homepage] <br> [michele][michele_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150

[pat_homepage]: https://github.com/pat
[pat_avatar]: https://github.com/pat.png?size=150

[Michele_homepage]:https://github.com/miki79
[Michele_avatar]: https://github.com/miki79.png?size=150

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
[Michele_homepage]:https://github.com/miki79
[Michele_avatar]: https://github.com/miki79.png?size=150

[logo]: https://gist.githubusercontent.com/JamesWoolfenden/5c457434351e9fe732ca22b78fdd7d5e/raw/15933294ae2b00f5dba6557d2be88f4b4da21201/slalom-logo.png
[website]: https://slalom.com
[linkedin]: https://www.linkedin.com/in/jameswoolfenden/
[linkedin]: https://www.linkedin.com/company/slalom-consulting/
[twitter]: https://twitter.com/JimWoolfenden

[share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-rdsinit&url=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-rdsinit&url=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_reddit]: https://reddit.com/submit/?url=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
[share_email]: mailto:?subject=terraform-aws-rdsinit&body=https://github.com/JamesWoolfenden/terraform-aws-rdsinit
