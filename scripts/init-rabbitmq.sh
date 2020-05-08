#!/usr/bin/env bash

if [ ! -f docker-compose.yml ]; then
    echo "You are not inside faf-stack! The working directory must be the root of faf-stack."
    exit 1
fi

MAX_WAIT=60 # max. 1 minute waiting time in loop before timeout

source config/faf-rabbitmq/faf-rabbitmq.env

docker-compose up -d faf-rabbitmq

# Create RabbitMQ users
docker-compose exec faf-rabbitmq rabbitmqctl wait --timeout ${MAX_WAIT} "${RABBITMQ_PID_FILE}"

docker-compose exec faf-rabbitmq rabbitmqctl add_vhost "${RABBITMQ_POSTAL_VHOST}"
docker-compose exec faf-rabbitmq rabbitmqctl add_user "${RABBITMQ_POSTAL_USER}" "${RABBITMQ_POSTAL_PASS}"
docker-compose exec faf-rabbitmq rabbitmqctl set_permissions -p "${RABBITMQ_POSTAL_VHOST}" "${RABBITMQ_POSTAL_USER}" ".*" ".*" ".*"

docker-compose exec faf-rabbitmq rabbitmqctl add_vhost "${RABBITMQ_LOBBYSERVER_VHOST}"
docker-compose exec faf-rabbitmq rabbitmqctl add_user "${RABBITMQ_LOBBYSERVER_USER}" "${RABBITMQ_LOBBYSERVER_PASS}"
docker-compose exec faf-rabbitmq rabbitmqctl set_permissions -p "${RABBITMQ_LOBBYSERVER_VHOST}" "${RABBITMQ_LOBBYSERVER_USER}" ".*" ".*" ".*"
