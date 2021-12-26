#!/bin/bash

CONSUL_VERSION=1.11.1

if [ "$1" = '--generate-certificats' ]; then
    mkdir -p certs
    ./bin/mkcert -install
    ./bin/mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "docker.localhost" "*.docker.localhost"
fi

if [ "$1" = '--start' ]; then
    docker network create public-subnet
    docker-compose -f traefik/docker-compose.yaml up -d
    docker-compose -f consul-server/docker-compose.yaml up -d
fi

if [ "$1" = '--stop' ]; then
    docker-compose -f consul-server/docker-compose.yaml down
    docker-compose -f traefik/docker-compose.yaml down
    docker network rm public-subnet
fi

if [ "$1" = '--start-consul-server' ]; then
    consul_server_1="$(docker exec -it consul-server-1 ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)"
    consul_server_2="$(docker exec -it consul-server-2 ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)"
    consul_server_3="$(docker exec -it consul-server-3 ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)"
    docker_ips="${consul_server_1}, ${consul_server_2}, ${consul_server_3}"
    cd consul-server
    ../bin/terraform init -var="consul_version=${CONSUL_VERSION}" -var="docker_ips=${docker_ips}"
    ../bin/terraform apply -var="consul_version=${CONSUL_VERSION}" -var="docker_ips=${docker_ips}" -auto-approve
fi