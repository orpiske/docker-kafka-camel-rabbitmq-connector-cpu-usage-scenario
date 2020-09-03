#!/usr/bin/env bash
# Inspired by https://github.com/1ambda/docker-kafka-connect/tree/master/1.1.0

tag="[entrypoint.sh]"

function info {
  echo "$tag (INFO) : $1"
}
function warn {
  echo "$tag (WARN) : $1"
}
function error {
  echo "$tag (ERROR): $1"
}

echo ""
info "Starting..."

CONNECT_PID=0

handleSignal() {
  info 'Stopping... '
  if [ $CONNECT_PID -ne 0 ]; then
    kill -s TERM "$CONNECT_PID"
    wait "$CONNECT_PID"
  fi
  info 'Stopped'
  exit
}

trap "handleSignal" SIGHUP SIGINT SIGTERM

/kafka/connect/app/bin/connect-distributed.sh /kafka/connect/config/connect-distributed.properties &
CONNECT_PID=$!

wait