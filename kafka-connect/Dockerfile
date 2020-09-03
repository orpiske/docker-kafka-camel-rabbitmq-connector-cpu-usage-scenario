FROM openjdk:8-jre-alpine

ARG VERSION_APACHE_KAFKA=2.2.1
ARG VERSION_SCALA=2.12
ARG VERSION_APACHE_CAMEL=0.4.0

RUN mkdir -p /kafka/connect/plugins && \
    mkdir -p /kafka/connect/app && \
    mkdir -p /kafka/connect/config && \
    wget https://archive.apache.org/dist/kafka/${VERSION_APACHE_KAFKA}/kafka_${VERSION_SCALA}-${VERSION_APACHE_KAFKA}.tgz -q -O kafka.tgz && \
    tar -xzf kafka.tgz -C /kafka/connect/app --strip 1 && \
    rm -f kafka.tgz && \
    wget https://repo1.maven.org/maven2/org/apache/camel/kafkaconnector/camel-rabbitmq-kafka-connector/${VERSION_APACHE_CAMEL}/camel-rabbitmq-kafka-connector-${VERSION_APACHE_CAMEL}-package.zip -q -O rabbitmq-connector.zip && \
    unzip -qq rabbitmq-connector.zip -d /kafka/connect/plugins && \
    rm -f rabbitmq-connector.zip && \
    apk add -q --no-cache bash

COPY entrypoint.sh /kafka/connect/entrypoint.sh
COPY connect-distributed.properties /kafka/connect/config/connect-distributed.properties
COPY log4j.properties /kafka/connect/config/log4j.properties
RUN chmod +x /kafka/connect/entrypoint.sh

ENTRYPOINT [ "/kafka/connect/entrypoint.sh" ]