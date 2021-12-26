#!/bin/bash

TERRAFORM_VERSION=1.1.2
MKCERT_VERSION=1.4.3

rm -rf ./bin
mkdir ./bin

# Download terraform
echo "[INFO] download terraform"
curl -sLo ./terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip ./terraform.zip -d ./bin
rm ./terraform.zip
chmod +x ./bin/terraform
echo "[INFO] terraform v${TERRAFORM_VERSION} installed"

# Download mkcert
echo "[INFO] download mkcert"
curl -sLo ./mkcert https://github.com/FiloSottile/mkcert/releases/download/v${MKCERT_VERSION}/mkcert-v${MKCERT_VERSION}-linux-amd64
mv ./mkcert bin/
chmod +x ./bin/mkcert
echo "[INFO] mkcert v${MKCERT_VERSION} installed"