#!/bin/bash

if [ "$1" = "--generate" ]; then
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
fi

if [ "$1" = "--deploy-apply" ]; then
    cd terraform
    ../bin/terraform init
    ../bin/terraform apply
fi

if [ "$1" = "--deploy-destroy" ]; then
    cd terraform
    ../bin/terraform init
    ../bin/terraform destroy
fi

if [ "$1" = "--start-consul" ]; then
    cd consul
    ../bin/vagrant up
fi

if [ "$1" = "--reload-consul" ]; then
    cd consul
    ../bin/vagrant reload --provision
fi

if [ "$1" = "--start-nomad" ]; then
    cd nomad
    ../bin/vagrant up
fi

if [ "$1" = "--reload-nomad" ]; then
    cd nomad
    ../bin/vagrant reload --provision
fi

if [ "$1" = "--start-nomad-clients" ]; then
    cd nomad-clients
    ../bin/vagrant up
fi

if [ "$1" = "--reload-nomad-clients" ]; then
    cd nomad-clients
    ../bin/vagrant reload --provision
fi

if [ "$1" = "--vault-init" ]; then
    initialized=$(curl -s https://vault.docker.localhost/v1/sys/init | jq -r .initialized)
    echo "[INFO] initialized=${initialized}"
    if [ $initialized = "true" ]; then
        exit 0
    fi
    docker exec -it vault-server /root/bin/vault operator init -format=json > data/vault.json
fi

if [ "$1" = "--vault-unseal" ]; then
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

if [ "$1" = "--stop-all" ]; then
    cd nomad-clients
    ../bin/vagrant destroy
    cd ..
    cd nomad
    ../bin/vagrant destroy
    cd ..
    cd consul
    ../bin/vagrant destroy
fi

if [ "$1" = "--stop-consul" ]; then
    cd consul
    ../bin/vagrant destroy
fi

if [ "$1" = "--stop-nomad" ]; then
    cd nomad
    ../bin/vagrant destroy
fi

if [ "$1" = "--stop-nomad-clients" ]; then
    cd nomad-clients
    ../bin/vagrant destroy
fi