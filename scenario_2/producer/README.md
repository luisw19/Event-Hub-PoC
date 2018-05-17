### To Start

- Run producer.sql into Oracle DB
- Identify the container ID running Confluent Connect
```docker
  sudo docker-compose ps
```
- Load the OJDBC Jar into Docker Connect Container - Replace `<CONTAINER_ID>`
```docker
  sudo docker cp ../producer/ojdbc8.jar <CONTAINER_ID>:/ojdbc8.jar
```

- Login to connect container
```
  sudo docker-compose exec connect bash
```

- Update the following connect `/etc/schema-registry/connect-avro-standalone.properties` property values (The rest can be left as default)
```
  bootstrap.servers=broker:9092
  key.converter.schema.registry.url=http://schema_registry:8081
  value.converter.schema.registry.url=http://schema_registry:8081
  rest.port=28083
```
- Create the following connect `/etc/kafka-connect-jdbc/source-quickstart-oracle.properties` property file - Be sure to replace `<HOST IP>`
```
  name=test-oracle-jdbc-autoincrement
  connector.class=io.confluent.connect.jdbc.JdbcSourceConnector
  tasks.max=1
  connection.password = MyPasswd123
  connection.url = jdbc:oracle:thin:@<HOST IP>:1527:DBKAFKA
  connection.user = sys as sysdba
  table.whitelist=PROD_ITEM
  mode=timestamp+incrementing
  incrementing.column.name=ITEM_ID
  timestamp.column.name=MODIFIED
  topic.prefix=test-oracle-jdbc-
```

- Run the new connect server
```
  /usr/bin/connect-standalone /etc/schema-registry/connect-avro-standalone.properties /etc/kafka-connect-jdbc/source-quickstart-oracle.properties
```

- In the Oracle DB, insert records into `PROD_ITEM` to tirgger a message being produced, OR, update the `MODIFIED` column

- The topic messaged are produced to is `test-oracle-jdbc-PROD_ITEM` - This is automatically created