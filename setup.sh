#!/bin/bash

topic_name="rabbitmqtest"
topics=$(docker exec camel_demo_kafka1 kafka-topics --list --bootstrap-server kafka1:19092,kafka2:19093,kafka3:19094)

if [[ ! "$topics" =~ "$topic_name" ]]; then 
    echo "Topic $topic_name does not exist yet. Creating it."
    docker exec camel_demo_kafka1 kafka-topics --create --topic "$topic_name" --partitions 10 --replication-factor 3 --bootstrap-server kafka1:19092,kafka2:19093,kafka3:19094
else
    echo "Topic $topic_name already exists."
fi

connector_name="rabbitmqtest"
connectors=$(curl -s http://127.0.0.1:8083/connectors)

exchange_name="X.test"
queue_name="Q.test.kafka.import"
rabbitmq_user="rabbitmq"
rabbitmq_pass="rabbitmq"
echo "Creating exchange $exchange_name"
curl -u "$rabbitmq_user:$rabbitmq_pass" -H "content-type:application/json" \
    -X PUT -d'{"type":"topic","durable":true}' \
    "http://localhost:15672/api/exchanges/%2f/$exchange_name"

if [[ ! "$connectors" =~ "$connector_name" ]]; then
    echo "Connector $connector_name does not exist yet. Creating it."
    cat << EOF | curl -X POST -H "Content-Type: application/json" -d @- http://127.0.0.1:8083/connectors
    {
        "name": "$connector_name",
        "config": {
          "connector.class": "org.apache.camel.kafkaconnector.rabbitmq.CamelRabbitmqSourceConnector",
          "topics": "$topic_name",
          "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
          "tasks.max": 10,
          "camel.component.rabbitmq.hostname": "rabbitmq",
          "camel.component.rabbitmq.portNumber": 5672,
          "camel.component.rabbitmq.username": "$rabbitmq_user",
          "camel.component.rabbitmq.password": "$rabbitmq_pass",
          "camel.source.path.exchangeName": "$exchange_name",
          "camel.source.endpoint.exchangeType": "topic",
          "camel.source.endpoint.autoDelete": false,
          "camel.source.endpoint.queue": "$queue_name",
          "camel.source.endpoint.routingKey": "events"
        }
      }
EOF
else
    echo "Connector $connector_name already exists."
fi

echo "CPU usage as reported by top (Irix mode) in the Kafka Connect container"
docker exec camel_demo_kafka_connect top -b -n 1