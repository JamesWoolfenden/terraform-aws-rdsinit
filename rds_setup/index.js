// For rds_setup/index.js
const fs = require('fs'),
      pg = require('pg');

exports.handler = async (event, context) => {
  const record = JSON.parse(event.Records[0].Sns.Message);
  console.log(record);

  var credentials = {
    user:     record.user,
    database: record.database,
    host:     record.host,
    port:     record.port,
    ssl:      {
      rejectUnauthorized: false,
      cert:               fs.readFileSync("./rds-cert.pem").toString()
    }
  };

  const pgClient = new pg.Client(credentials);

  await pgClient.connect();
  var results = await pgClient.query(process.env.SQL_SCRIPT);
  await pgClient.end();

  console.log(results.map(function(result) { return result.rowCount; }));
};
