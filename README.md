# Event-Hub-PoC
This is the repository for an Event Hub PoC.

The Development environment (under /environment) is based on the following repositories:

- Official confluent docker-compose:
https://github.com/confluentinc/cp-docker-images/blob/4.0.x/examples/cp-all-in-one/docker-compose.yml

- Guido Schmutz environment:
https://github.com/gschmutz/infrastructure-soaring-clouds-sequel/tree/master/docker

Also recommend reading the following tutorial:
https://docs.confluent.io/3.0.0/control-center/docs/quickstart.html

## Windows 7 Docker Install
https://docs.docker.com/toolbox/toolbox_install_windows/

## To start environment

1) Install docker and docker-compose

2) Set the environment variable DOCKER_HOST_IP to the IP address of your docker host: (NOT NEEEDED LOCALLY)
```bash
export DOCKER_HOST_IP=<IP address of your Docker Host>
```

3) Under /environment the following command

```bash
	docker-compose up -d
```
This will start:

* Zookeeper on port 2181
* A Kafka Broker listening on port 9092

The following APIs are available

* Kafka Broker REST API: [http://localhost:8084](http://localhost:8084) ([doc](https://docs.confluent.io/current/kafka-rest/docs/api.html#api-v2))
* Schema Registry REST API: [http://localhost:8081](http://localhost:8081) ([doc](https://docs.confluent.io/current/schema-registry/docs/api.html#overview))

3) The following management UI's can be accessed:

* Confluent Control Center: [http://localhost:9021](http://localhost:9021)
* Schema Registry UI: [http://localhost:8002](http://localhost:8002)
* Kafka Connect UI: [http://localhost:8001](http://localhost:8001)

## Environment Configuration (Large Messages)

As part of the Docker/Kafka configuration, the HEAP size needs to be increased on the Broker, Connect and Rest Proxy containers.
The broker and connect containers need the server.properties file amending if you're sending messages over 100MB.

### 1) Broker Configuration
```
docker-compose exec broker bash

apt-get update

apt-get install vim
```

The file `/usr/bin/kafka-run-class` needs to be changed to update the heap size

```
vi /usr/bin/kafka-run-class
```

In the vi window, find the KAFKA_HEAP_OPTS value and change it from `KAFKA_HEAP_OPTS="-Xmx256M"` to `KAFKA_HEAP_OPTS="-Xmx4096M"`
Then Save and Quit the vi application. `:wq`

The file `/etc/kafka/server.properties` needs to be changed to update the maximum request size (in bytes) the server will accept

```
vi /etc/kafka/server.properties
```

In the vi window, find the `socket.request.max.bytes` value and change it from `104857600` to a number of bytes larger than your expected message.
Then Save and Quit the vi application. `:wq`

After editing the two files, the broker container needs to be restarted to detect the new changes

```
exit

docker-compose stop broker

docker-compose start broker
```

### 2) Connect Configuration
```
docker-compose exec connect bash

apt-get update

apt-get install vim
```

The file `/usr/bin/kafka-run-class` needs to be changed to update the heap size

```
vi /usr/bin/kafka-run-class
```

In the vi window, find the KAFKA_HEAP_OPTS value and change it from `KAFKA_HEAP_OPTS="-Xmx256M"` to `KAFKA_HEAP_OPTS="-Xmx4096M"`
Then Save and Quit the vi application. `:wq`

The file `/etc/kafka/server.properties` needs to be changed to update the maximum request size (in bytes) the server will accept

```
vi /etc/kafka/server.properties
```

In the vi window, find the `socket.request.max.bytes` value and change it from `104857600` to a number of bytes larger than your expected message.
Then Save and Quit the vi application. `:wq`

After editing the two files, the connect container needs to be restarted to detect the new changes

```
exit

docker-compose stop connect

docker-compose start connect
```

### 3) Rest Proxy Configuration
```
docker-compose exec rest-proxy bash

apt-get update

apt-get install vim
```

The file `/usr/bin/kafka-rest-run-class` needs to be changed to update the heap size

```
vi /usr/bin/kafka-rest-run-class
```

In the vi window, find the KAFKA_HEAP_OPTS value and change it from `KAFKA_HEAP_OPTS="-Xmx256M"` to `KAFKA_HEAP_OPTS="-Xmx4096M"`
Then Save and Quit the vi application. `:wq`

After editing the file, the rest proxy container needs to be restarted to detect the new changes

```
exit

docker-compose stop rest-proxy

docker-compose start rest-proxy
```

Now the environment should be ready to produce large messages - The retreival of large messages is still WIP.

## Quickstart Examples

1) Create Kafka Topic:
```docker
docker-compose exec broker kafka-topics --create --topic itemTest --partitions 1 --replication-factor 1 --if-not-exists --zookeeper zookeeper:2181
```

2) Create item schema using [Schema Registry UI](http://localhost:8002)
* Schema Name: itemTest
* Note the Schema ID after creating schema

3) Connect to broker box
```
docker-compose exec broker bash
```

4) Register new consumer group with a new consumer instance
```
curl -d '{"name":"test","format":"avro","auto.offset.reset":"earliest"}' -H "Content-Type: application/vnd.kafka.v2+json" -X POST http://rest-proxy:8084/consumers/test_consumer
```

5) Subscribe consumer instance to a topic
```
curl -d '{"topics":["itemTest"]}' -H "Content-Type: application/vnd.kafka.v2+json" -X POST http://rest-proxy:8084/consumers/test_consumer/instances/test/subscription
```

6) Exit the broker container
```
exit
```

7) POST Messages -- Ensure in the JSON file, the "value_schema_id" is the same as the one from Step 2
```
ab -v 2 -p data_medium_2.json -T application/vnd.kafka.avro.v2+json -H 'Accept: application/vnd.kafka.v2+json' -c 1 -n 1 http://localhost:8084/topics/itemTest
```

8) GET Messages
```
ab -v 2 -H 'Accept: application/vnd.kafka.avro.v2+json' -c 1 -n 1 http://localhost:8084/consumers/test_consumer/instances/test/records
```