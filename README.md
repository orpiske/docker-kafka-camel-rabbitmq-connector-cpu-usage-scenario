# Reproduce Issue Reported in https://github.com/apache/camel-kafka-connector/issues/414

This repository contains a [docker-compose](./docker-compose.yml) file to reproduce the
issue reported in https://github.com/apache/camel-kafka-connector/issues/414.

Steps to reproduce the high CPU usage:

1. Run `docker-compose up` (optionally add the `-d` flag to run in detached mode) and wait until all services are up and running
2. Execute `bash setup.sh` to create a Kafka topic, setup a RabbitMQ exchange, and configure the Camel RabbitMQ connector. Once
   the setup is finished, the script will report the CPU consumption (via `top` in Irix mode) and 5 seconds later again.

You can also connect to the Kafka Connect Java process via JMX at port `9010`, e.g. by using VisualVM.