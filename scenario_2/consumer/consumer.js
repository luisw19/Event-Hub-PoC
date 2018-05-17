var KafkaAvro = require('kafka-avro');
var oracledb = require('oracledb');
var dbConfig = require('./dbconfig.js');

function longToHex(long) {
  if (!long) {
    return null;
  }
  return parseInt(long.toString('hex'), 16);
}

function longToDate(long) {
  if (!long) {
    return null;
  }
  return new Date(Number(long));
}

var connection;

var insertString = "INSERT INTO CONS_ITEM (cons_item_id, source_item_id, item_no, item_type_id, item_state_id, register_date, update_date, delete_date, modified, source_creation_date, sink_receive_date, sink_creation_date" +
                   ") VALUES (cons_item_id_seq.NEXTVAL, :source_item_id, :item_no, :item_type_id, :item_state_id, :register_date , :update_date, :delete_date, :modified, :source_creation_date, :sink_receive_date , SYSDATE)";

oracledb.getConnection({
  user : dbConfig.user,
  password : dbConfig.password,
  connectString : dbConfig.connectString,
  privilege     : oracledb.SYSDBA
}, function(err, conn) {
  if (err) {
    return;
  }
  connection = conn;
});

var kafkaLog  = KafkaAvro.getLogger();

var kafkaAvro = new KafkaAvro({
    kafkaBroker: '127.0.0.1:9092',
    schemaRegistry: 'http://144.21.81.52:8081',
    fetchAllVersion: true,
    parseOptions: { wrapUnions: true }
});

kafkaAvro.init().then(function() {

  console.log('Avro ready to use');

  kafkaAvro.getConsumerStream({
    'group.id': 'kafka',
    'socket.keepalive.enable': true,
    'enable.auto.commit': true,
  },
  {
    'request.required.acks': 1
  },
  {
    'topics': 'test-oracle-jdbc-PROD_ITEM'
  }).then(function(stream) {

    stream.on('error', function(err) {
      console.log(err);
      connection.close();
      process.exit(1);
    });
  
    stream.on('data', function(rawData) {

      var dateReceived = new Date();

      var itemId = longToHex(rawData.parsed.ITEM_ID);
      var itemNo = longToHex(rawData.parsed.ITEM_NO.bytes);
      var itemTypeId = longToHex(rawData.parsed.ITEM_TYPE_ID.bytes);
      var itemStateId = longToHex(rawData.parsed.ITEM_STATE_ID.bytes);
      var registerDate = longToDate(rawData.parsed.REGISTER_DATE.long);
      var updateDate = longToDate(rawData.parsed.UPDATE_DATE.long);
      var deleteDate = longToDate(rawData.parsed.DELETE_DATE.long);
      var creationDate = longToDate(rawData.parsed.CREATION_DATE.long);
      var modified = longToDate(rawData.parsed.MODIFIED);

      console.log('Message received: ' + dateReceived + ' with Item ID: ' + itemId);
        // console.log('Data:', rawData);
        // console.log('Item ID:', longToHex(rawData.parsed.ITEM_ID));
        // console.log('Item No:', longToHex(rawData.parsed.ITEM_NO.bytes));
        // console.log('Item Type ID:', longToHex(rawData.parsed.ITEM_TYPE_ID.bytes));
        // console.log('Item State ID:', longToHex(rawData.parsed.ITEM_STATE_ID.bytes));
        // console.log('Register Date:', longToDate(rawData.parsed.REGISTER_DATE.long));
        // console.log('Update Date:', longToDate(rawData.parsed.UPDATE_DATE.long));
        // console.log('Delete Date:', longToDate(rawData.parsed.DELETE_DATE.long));
        // console.log('Creation Date:', longToDate(rawData.parsed.CREATION_DATE.long));
        // console.log('Modified:', longToDate(rawData.parsed.MODIFIED));

      connection.execute(
        insertString,
        {
          source_item_id : {
            val: itemId
          },
          item_no : {
            val: itemNo
          },
          item_type_id : {
            val: itemTypeId
          },
          item_state_id : {
            val: itemStateId
          },
          register_date : {
            val: registerDate
          },
          update_date : {
            val: updateDate
          },
          delete_date : {
            val: deleteDate
          },
          modified : {
            val: modified
          },
          source_creation_date : {
            val: creationDate
          },
          sink_receive_date : {
            val: dateReceived
          }
        },
        {autoCommit: true},
        function(err, result) {
          if (err) {
            console.log(err);
            console.log(result);
            return err;
          } else {
            console.log("Rows inserted: " + result.rowsAffected);
          }
        }
      );

    });

    stream.consumer.on('event.error', function(err) {
      console.log(err);
      connection.close();
    });

    stream.consumer.on('event.log', function(err) {
      console.log(err);
    });
  
  });

});

