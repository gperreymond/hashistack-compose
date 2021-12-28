#!/bin/bash

CONSUL_VERSION=1.11.1

if [ "$1" = '--generate-certificats' ]; then
    mkdir -p certs
    ./bin/mkcert -install
    ./bin/mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "docker.localhost" "*.docker.localhost"
fi

if [ "$1" = '--start' ]; then
    mkdir -p data
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
    rm -rf data
fi

if [ "$1" = '--vault-init' ]; then
    initialized=$(curl -s https://vault.docker.localhost/v1/sys/init | jq -r .initialized)
    echo "[INFO] initialized=${initialized}"
    if [ $initialized = "true" ]; then
        exit 0
    fi
    docker exec -it vault-server /root/bin/vault operator init -format=json > data/vault.json
fi

if [ "$1" = '--vault-unseal' ]; then
    sealed=$(curl -s https://vault.docker.localhost/v1/sys/seal-status | jq -r .sealed)
    echo "[INFO] sealed=${sealed}"
    if [ $sealed = "true" ]; then
        root_token=$(cat ./data/vault.json | jq -r .root_token)
        echo "[INFO] root_token=${root_token}"
        unseal_key_1=$(cat ./data/vault.json | jq -r .unseal_keys_b64[0])
        echo "[INFO] unseal_key_1=${unseal_key_1}"
        unseal_key_2=$(cat ./data/vault.json | jq -r .unseal_keys_b64[1])
        echo "[INFO] unseal_key_2=${unseal_key_2}"
        unseal_key_3=$(cat ./data/vault.json | jq -r .unseal_keys_b64[2])
        echo "[INFO] unseal_key_3=${unseal_key_3}"
        curl -s -X PUT -d "{\"key\":\"${unseal_key_1}\"}" -H "Content-Type: application/json" https://vault.docker.localhost/v1/sys/unseal | jq
        curl -s -X PUT -d "{\"key\":\"${unseal_key_2}\"}" -H "Content-Type: application/json" https://vault.docker.localhost/v1/sys/unseal | jq
        curl -s -X PUT -d "{\"key\":\"${unseal_key_3}\"}" -H "Content-Type: application/json" https://vault.docker.localhost/v1/sys/unseal | jq
    fi
fi