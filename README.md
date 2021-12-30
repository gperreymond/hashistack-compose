# HASHISTACK COMPOSE

### Pricipals

* Simulate the internet public ips with docker network named __public-subnet__
* Each docker compose files represents an instance
* Nomad clients, provided with a vagrant procedure

### Work in progress

* [x] Docker base image with consul, nomad and vault
* [x] Certificats with mkcert
* [x] Consul servers x3
* [x] Nomad servers x3 with consul client
* [x] Nomad clients x2 with consul client (Vagrant provisionning)
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
# Start the 2 nomad clients
$ ./bootstrap.sh --start-nomad-clients
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