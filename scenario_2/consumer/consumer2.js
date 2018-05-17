'use strict';

var kafka = require('kafka-node');
var HighLevelConsumer = kafka.HighLevelConsumer;
var Client = kafka.Client;
var client = new Client('127.0.0.1:2181');
var topics = [{ topic: 'test-oracle-jdbc-PROD_ITEM' }];
var options = { autoCommit: true, fetchMaxWaitMs: 1000, fetchMaxBytes: 1024 * 1024 };
var consumer = new HighLevelConsumer(client, topics, options);

consumer.on('message', function (message) {
  console.log(message);
  console.log(message.value);
});

consumer.on('data', function (data) {
  console.log(data);
});

consumer.on('error', function (err) {
  console.log('error', err);
});
