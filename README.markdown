This Terraform configuration allows running a set of SQL commands on a new AWS RDS database instance that's operating within an AWS VPC.

The commands are executed via AWS Lambda functions - the first (`rds_creation`) operates outside the VPC and connects to the AWS API to determine credential information for the new database (endpoint, port, username, database). It then sends these details via SNS to another function operating _within_ the VPC (`rds_setup`), which connects to the PostgreSQL database and executes the SQL commands.

The initial notification comes via SNS from the RDS events (and there is the configuration within the Terraform file here to set up that subscription).

Please note:

* There are variables defined at the top of the Terraform file - everything else should be pretty self-contained (though you should definitely read through all of the code to ensure you understand it before using it).
* The internal Lambda function is expecting a PostgreSQL database. This will need changing if you're going to use MySQL/Aurora/etc.
* The internal Lambda function connects via SSL, and so requires a local copy of the [AWS SSL Certificate file](https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem) (which I have saved as `rds-cert.pem` within the `rds_setup` directory).

```cli
curl https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -o ./rds_setup/rds-cert.pem
```

* Build the lambdas

Each lambda function is stored within their respective folders (`rds_creation`, `rds_setup`), and also have `package.json` files to go within them as well.

```cli
npm install
```

If you think there's a better way of doing this, shoot me a message on [Twitter](https://twitter.com/pat).