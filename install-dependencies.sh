#!/bin/bash

MKCERT_VERSION=1.4.3

rm -rf ./bin
mkdir ./bin

# Download mkcert
echo "[INFO] download mkcert"
curl -sLo ./mkcert https://github.com/FiloSottile/mkcert/releases/download/v${MKCERT_VERSION}/mkcert-v${MKCERT_VERSION}-linux-amd64
mv ./mkcert bin/
chmod +x ./bin/mkcert
echo "[INFO] mkcert v${MKCERT_VERSION} installed"