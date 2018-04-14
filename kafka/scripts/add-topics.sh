#!/bin/bash

if [[ -z "$KAFKA_CREATE_TOPICS" ]]; then
    exit 0
fi

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=600
fi

start_timeout_exceeded=false
count=0
step=10
# assumes default Kafka port of 9092
while netstat -lnt | awk '$4 ~ /:'"9092"'$/ {exit 1}'; do
    echo "waiting for kafka to be ready"
    sleep $step;
    count=$((count + step))
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if $start_timeout_exceeded; then
    echo "Not able to auto-create topic (waited for $START_TIMEOUT sec)"
    exit 1
fi

#!/bin/bash
# Add Kafka topics...
echo "Adding topics..."
$KAFKA_HOME/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic trade-statistic --partitions 1 --replication-factor 1

