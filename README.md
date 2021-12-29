# HASHISTACK COMPOSE

### Pricipals

* Each docker compose files represents an instance
* An example of nomad client is provided with a vagrant procedure

### Work in progress

* [x] Docker base image with consul, nomad and vault
* [x] Certificats with mkcert
* [x] Consul servers x3
* [x] Nomad servers x3 with consul client
* [x] Nomad client with consul client
* [x] Vault server x1 with consul client
* [x] Vault init and unseal
* [x] Consul gossip encryption enabled
* [x] Consul tls enabled
* [x] Monitoring Prometheus enabled
* [x] Consul servers prometheus exporters
* [x] Monitoring Grafana enabled
* [x] Monitoring Grafana: Consul dashboard
* [x] Monitoring Prometheus: Consul alerts

### How to bootstrap the hashistack ?

You need VirtualBox installed for Vagrant.

```sh
# Only one time
$ sudo apt install -y libarchive-dev libarchive-tools # for vagrant
$ sudo apt install libnss3-tools # for mkcert
$ ./install-depencencies.sh
$ docker build -t hashistack-alpine:1.0.0 .
$ ./bootstrap.sh --generate-security
# Start
$ ./bootstrap.sh --start
# Vault, do it once only each time the stack was down to up
$ ./bootstrap.sh --vault-init
$ ./bootstrap.sh --vault-unseal
# Stop
$ ./bootstrap.sh --stop
```

### How to run the nomad client ?

```sh
$ cd nomad-client
$ ../bin/vagrant up
```

### External urls

* https://traefik.docker.localhost
* https://consul.docker.localhost
* https://nomad.docker.localhost
* https://vault.docker.localhost
* https://prometheus.docker.localhost
* https://grafana.docker.localhost