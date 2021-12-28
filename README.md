* [x] Docker base image with consul, nomad and vault
* [x] Certificats with mkcert
* [x] Consul servers x3
* [x] Nomad servers x3 with consul client
* [x] Nomad client with consul client
* [x] Vault server x1


```sh
# Only one time
$ sudo apt install libnss3-tools # for mkcert
$ ./install-depencencies.sh
$ docker build -t hashistack-alpine:1.0.0 .
$ ./bootstrap.sh --generate-certificats
# Start
$ ./bootstrap.sh --start
# Vault, do it once only each time the stack was down to up
$ ./bootstrap.sh --vault-init
$ ./bootstrap.sh --vault-unseal
# Stop
$ ./bootstrap.sh --stop
```
