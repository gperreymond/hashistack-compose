#!/bin/bash

TERRAFORM_VERSION=1.1.2

rm -rf ./bin
mkdir ./bin

rm -rf ./tmp
mkdir ./tmp

# Download terraform
echo "[INFO] download terraform"
curl -sLo ./terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip ./terraform.zip -d ./bin
rm ./terraform.zip
chmod +x ./bin/terraform
echo "[INFO] terraform v${TERRAFORM_VERSION} installed"
