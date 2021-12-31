#!/bin/bash

MKCERT_VERSION=1.4.3
CONSUL_VERSION=1.11.1
NOMAD_VERSION=1.2.3
VAULT_VERSION=1.9.2
VAGRANT_VERSION=2.2.19

rm -rf ./bin
mkdir ./bin

# Download mkcert
echo "[INFO] download mkcert"
curl -sLo ./mkcert https://github.com/FiloSottile/mkcert/releases/download/v${MKCERT_VERSION}/mkcert-v${MKCERT_VERSION}-linux-amd64
mv ./mkcert bin/
chmod +x ./bin/mkcert
echo "[INFO] mkcert v${MKCERT_VERSION} installed"

# Download consul
echo "[INFO] download consul"
curl -sLo ./consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
unzip ./consul.zip -d ./bin
rm ./consul.zip
chmod +x ./bin/consul
echo "[INFO] consul v${CONSUL_VERSION} installed"

# Download nomad
echo "[INFO] download nomad"
curl -sLo ./nomad.zip https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
unzip ./nomad.zip -d ./bin
rm ./nomad.zip
chmod +x ./bin/nomad
echo "[INFO] nomad v${NOMAD_VERSION} installed"

# Download vault
echo "[INFO] download vault"
curl -sLo ./vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip ./vault.zip -d ./bin
rm ./vault.zip
chmod +x ./bin/vault
echo "[INFO] vault v${VAULT_VERSION} installed"

# Download vagrant
echo "[INFO] download vagrant"
curl -sLo ./vagrant.zip https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_linux_amd64.zip
unzip ./vagrant.zip -d ./bin
rm ./vagrant.zip
chmod +x ./bin/vagrant
echo "[INFO] vagrant v${VAGRANT_VERSION} installed"