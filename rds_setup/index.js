const AWS = require("aws-sdk");

const parameterStore = new AWS.SSM({ region: process.env.REGION });
const s3 = new AWS.S3();
const { Client } = require("pg");
const bucketName = process.env.BUCKET; // S3 bucket containing rds-cert and query commands
const dbPassParamPath = process.env.DB_PASSWORD_PATH; // Parameter store path for the DB password
const queryCommandsKey = process.env.QUERY_COMMANDS_KEY; // S3 key of query commands
const tableName = process.env.TABLE_NAME || "authentic";
const rdsCertKey = process.env.RDS_CERT_KEY || "rds-cert.pem";
const getS3Object = async (bucket, key) => {
  var getParams = {
    Bucket: bucket,
    Key: key
  };
  return s3
    .getObject(getParams)
    .promise()
    .then(data => {
      return data.Body.toString("utf-8");
    });
};
const getSecureParam = async param => {
  return parameterStore
    .getParameter({
      Name: param,
      WithDecryption: true
    })
    .promise()
    .then(data => {
      return data.Parameter.Value;
    });
};
exports.handler = async event => {
  console.log(event);
  console.log(event.Records[0].Sns);
  const record = JSON.parse(event.Records[0].Sns.Message);
  console.log(record);
  let dbPassword;
  let rdsCert;
  let sql;
  // Get password, rds cert and query command
  const promises = [
    getSecureParam(dbPassParamPath),
    getS3Object(bucketName, rdsCertKey),
    getS3Object(bucketName, queryCommandsKey)
  ];
  await Promise.all(promises).then(data => {
    console.info(data);
    dbPassword = data[0];
    rdsCert = data[1];
    sql = data[2];
  });
  var credentials = {
    user: record.user,
    database: record.database,
    host: record.host,
    password: dbPassword,
    port: record.port,
    ssl: {
      rejectUnauthorized: false,
      cert: rdsCert
    }
  };
  // Create DB
  const createdb = `create database ${tableName}`;
  let pgClient = new Client(credentials);
  await pgClient.connect();
  const dbresults = await pgClient.query(createdb);
  console.log(dbresults);
  // need to switch dbs and populate DB
  credentials.database = tableName;
  const pgClientMain = new Client(credentials);
  await pgClientMain.connect();
  const results = await pgClientMain.query(sql);
  console.log(results);
  // Close DB connections
  pgClient.end();
  pgClientMain.end();
};
