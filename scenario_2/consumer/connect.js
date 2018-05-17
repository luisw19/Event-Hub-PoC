var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');

oracledb.getConnection(
{
user : dbConfig.user,
password : dbConfig.password,
connectString : dbConfig.connectString,
privilege     : oracledb.SYSDBA
},
function(err, connection)
{
if (err) {
console.error("KK " + oracledb.SYSDBA);
console.error(err.message);
return;
}
console.log('Connection was successful!');

connection.close(
function(err)
{
if (err) {
console.error("k " + oracledb.SYSDBA);
console.error(err.message);
return;
}
});
});
