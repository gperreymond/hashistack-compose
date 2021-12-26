#!/bin/bash

CONSUL_VERSION=1.11.1

if [ "$1" = '--generate-certificats' ]; then
    mkdir -p certs
    ./bin/mkcert -install
    ./bin/mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "docker.localhost" "*.docker.localhost"
fi

if [ "$1" = '--start' ]; then
    docker network create \
        --driver=bridge \
        --gateway "172.0.10.1" \
        --subnet "172.0.10.0/24" \
        public-subnet
    docker-compose -f traefik/docker-compose.yaml up -d
    docker-compose -f consul/docker-compose.yaml up -d
fi

if [ "$1" = '--stop' ]; then
    docker-compose -f consul/docker-compose.yaml down
    docker-compose -f traefik/docker-compose.yaml down
    docker network rm public-subnet
fi
