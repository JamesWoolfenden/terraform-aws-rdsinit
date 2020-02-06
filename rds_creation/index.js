// For rds_creation/index.js
const rds = require("aws-sdk/clients/rds"),
  sns = require("aws-sdk/clients/sns");

const awsClient = new rds();
const snsClient = new sns();

exports.handler = async (event, context) => {
  const record = JSON.parse(event.Records[0].Sns.Message);

  if (record["Event Source"] != "db-instance") {
    return;
  }
  if (record["Event Message"] != "DB instance created") {
    return;
  }

  console.log("Requesting instance information for " + record["Source ID"]);
  var data = await awsClient
    .describeDBInstances({ DBInstanceIdentifier: record["Source ID"] })
    .promise();

  if (data.DBInstances.length == 0) {
    return;
  }

  var instance = data.DBInstances[0];
  var credentials = {
    user: instance.MasterUsername,
    database: instance.DBName,
    host: instance.Endpoint.Address,
    port: instance.Endpoint.Port
  };

  await snsClient
    .publish({
      Message: JSON.stringify(credentials),
      Subject: "Database Created",
      TopicArn: process.env.SNS_TOPIC_ARN
    })
    .promise();
};
