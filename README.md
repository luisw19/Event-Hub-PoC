# Event-Hub-PoC
This is the repository for an Event Hub PoC.

The Development environment (under /environment) is based on the following official Confluent Docker-Compose file: https://github.com/confluentinc/cp-docker-images/blob/4.0.x/examples/cp-all-in-one/docker-compose.yml

Tutorial on how to leverage the environment:
https://docs.confluent.io/3.0.0/control-center/docs/quickstart.html

## To start environment

## Run with Docker-Compose

1) Install docker and docker-compose

2) Under /environment the following command

```bash
	docker-compose up -d
```
This will start:

- Zookeeper on port 2181
- A Kafka Broker listening on port 9092
- A Schema Registry on 8081
- Control Center on 9021

3) Open Control Center by entering the following URL in the browser: http://localhost:9021/
