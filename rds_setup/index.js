// For rds_setup/index.js
const fs = require('fs'),
      pg = require('pg');
  
exports.handler = async (event, context) => {

  console.log(event);
  console.log(event.Records[0].Sns);
  
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


  var sql=fs.readFileSync("./invoke.sql").toString();
  var createdb=fs.readFileSync("./createdb.sql").toString();
  console.log(sql);
  
  const pgClient = new pg.Client(credentials);

  await pgClient.connect();
  var dbresults = await pgClient.query(createdb);
  await pgClient.end();
  console.log(dbresults);
  
  
  //
  // need to switch dbs
  credentials.database="authentic";
  const pgClientMain = new pg.Client(credentials);
  await pgClientMain.connect();
  var results = await pgClientMain.query(sql);
  await pgClientMain.end();
  console.log(results);
};
