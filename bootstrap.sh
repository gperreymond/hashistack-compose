#!/bin/bash

if [ "$1" = '--generate-security' ]; then
    mkdir -p certs
    # ssl certificats for traefik
    ./bin/mkcert -install
    ./bin/mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "docker.localhost" "*.docker.localhost"
    # consul: initialize the built-in CA
    ./bin/consul tls ca create
    # consul: create the server certificates
    ./bin/consul tls cert create -server -dc "europe-paris"
    # consul: move certificats
    mv consul-agent-ca.pem certs/
    mv consul-agent-ca-key.pem certs/
    mv europe-paris-server-consul-0-key.pem certs/
    mv europe-paris-server-consul-0.pem certs/
    # docker compose env vars
    echo "CONSUL_ENCRYPT=\"$(./bin/consul keygen)\"
" > localhost.env
fi

if [ "$1" = '--start' ]; then
    mkdir -p data
    # network
    docker network create \
        --driver=bridge \
        --gateway "172.0.10.1" \
        --subnet "172.0.10.0/24" \
        public-subnet
    # consul server
    docker-compose --env-file localhost.env -f consul/docker-compose-server-1.yaml up -d
    docker-compose --env-file localhost.env -f consul/docker-compose-server-2.yaml up -d
    docker-compose --env-file localhost.env -f consul/docker-compose-server-3.yaml up -d
    sleep 20
    # traefik
    docker-compose --env-file localhost.env -f traefik/docker-compose.yaml up -d
    # vault
    docker-compose --env-file localhost.env -f vault/docker-compose-server.yaml up -d
    # nomad server
    docker-compose --env-file localhost.env -f nomad/docker-compose-server-1.yaml up -d
    docker-compose --env-file localhost.env -f nomad/docker-compose-server-2.yaml up -d
    docker-compose --env-file localhost.env -f nomad/docker-compose-server-3.yaml up -d
    # nomad client
    docker-compose --env-file localhost.env -f nomad/docker-compose-client-1.yaml up -d
    # monitoring
    docker-compose --env-file localhost.env -f monitoring/docker-compose.yaml up -d
fi

if [ "$1" = '--stop' ]; then
    # monitoring
    docker-compose --env-file localhost.env -f monitoring/docker-compose.yaml down
    # nomad client
    docker-compose --env-file localhost.env -f nomad/docker-compose-client-1.yaml down
    # nomad server
    docker-compose --env-file localhost.env -f nomad/docker-compose-server-1.yaml down
    docker-compose --env-file localhost.env -f nomad/docker-compose-server-2.yaml down
    docker-compose --env-file localhost.env -f nomad/docker-compose-server-3.yaml down
    # vault
    docker-compose --env-file localhost.env -f vault/docker-compose-server.yaml down
    # traefik
    docker-compose --env-file localhost.env -f traefik/docker-compose.yaml down
    # consul server
    docker-compose --env-file localhost.env -f consul/docker-compose-server-1.yaml down
    docker-compose --env-file localhost.env -f consul/docker-compose-server-2.yaml down
    docker-compose --env-file localhost.env -f consul/docker-compose-server-3.yaml down
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