# Event-Hub-PoC
This is the repository for an Event Hub PoC.

The Development environment (under /environment) is based on the following repositories:

- Official confluent docker-compose:
https://github.com/confluentinc/cp-docker-images/blob/4.0.x/examples/cp-all-in-one/docker-compose.yml

- Guido Schmutz environment:
https://github.com/gschmutz/infrastructure-soaring-clouds-sequel/tree/master/docker

Also recommend reading the following tutorial:
https://docs.confluent.io/3.0.0/control-center/docs/quickstart.html

## To start environment

1) Install docker and docker-compose

2) Set the environment variable DOCKER_HOST_IP to the IP address of your docker host:
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
