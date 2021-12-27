#!/bin/bash

CONSUL_VERSION=1.11.1

if [ "$1" = '--generate-certificats' ]; then
    mkdir -p certs
    ./bin/mkcert -install
    ./bin/mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "docker.localhost" "*.docker.localhost"
fi

if [ "$1" = '--start' ]; then
    # network
    docker network create \
        --driver=bridge \
        --gateway "172.0.10.1" \
        --subnet "172.0.10.0/24" \
        public-subnet
    # traefik
    docker-compose -f traefik/docker-compose.yaml up -d
    # consul server
    docker-compose -f consul/docker-compose-server-1.yaml up -d
    docker-compose -f consul/docker-compose-server-2.yaml up -d
    docker-compose -f consul/docker-compose-server-3.yaml up -d
    sleep 20
    # vault
    docker-compose -f vault/docker-compose-server.yaml up -d
    # nomad server
    docker-compose -f nomad/docker-compose-server-1.yaml up -d
    docker-compose -f nomad/docker-compose-server-2.yaml up -d
    docker-compose -f nomad/docker-compose-server-3.yaml up -d
    # nomad client
    docker-compose -f nomad/docker-compose-client-1.yaml up -d
fi

if [ "$1" = '--stop' ]; then
    # nomad client
    docker-compose -f nomad/docker-compose-client-1.yaml down
    # nomad server
    docker-compose -f nomad/docker-compose-server-1.yaml down
    docker-compose -f nomad/docker-compose-server-2.yaml down
    docker-compose -f nomad/docker-compose-server-3.yaml down
    # vault
    docker-compose -f vault/docker-compose-server.yaml down
    # consul server
    docker-compose -f consul/docker-compose-server-1.yaml down
    docker-compose -f consul/docker-compose-server-2.yaml down
    docker-compose -f consul/docker-compose-server-3.yaml down
    # traefik
    docker-compose -f traefik/docker-compose.yaml down
    # network
    docker network rm public-subnet
fi

if [ "$1" = '--init-vault' ]; then
    initialized=$(curl -s https://vault.docker.localhost/v1/sys/init | jq -r .initialized)
    echo "[INFO] initialized=${initialized}"
    if [ $initialized = "true" ]; then
        exit 0
    fi
    echo "[INFO] unseal"
    curl -sX PUT --data '{"recovery_shares": 5, "recovery_threshold": 3}' https://vault.docker.localhost/v1/sys/init > vault.json
    cat vault.json
fi