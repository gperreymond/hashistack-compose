# HASHISTACK COMPOSE

### Architecture

* Simulate the internet public ips with docker network named __public-subnet__
* Each docker compose files represents an instance
* Nomad clients, provided with a vagrant procedure

### Work in progress

* [x] Certificats with mkcert
* [x] Docker base image with consul, nomad and vault
* [x] Consul servers x1
* [x] Nomad servers x1 with consul client
* [x] Vault server x1 with consul client
* [x] Nomad clients x1 with consul client
* [x] Vault init and unseal
* [x] Consul gossip encryption enabled
* [x] Consul tls enabled
* [x] Monitoring Prometheus enabled
* [x] Consul prometheus exporters
* [x] Monitoring Grafana enabled
* [x] Monitoring Grafana: Consul dashboard
* [x] Monitoring Prometheus: Consul alerts

### How to bootstrap the hashistack ?

You need VirtualBox installed for Vagrant.

```sh
# only one time, on your host
$ sudo apt install -y libarchive-dev libarchive-tools # for vagrant
$ sudo apt install libnss3-tools # for mkcert
$ ./install-depencencies.sh
$ ./bootstrap.sh --generate
# starting servers
$ ./bootstrap.sh --start-consul
$ ./bootstrap.sh --start-vault
$ ./bootstrap.sh --start-nomad
# vault, do it once only each time the stack was down to up
$ ./bootstrap.sh --vault-init
$ ./bootstrap.sh --vault-unseal
# start the 2 nomad clients
$ ./bootstrap.sh --start-nomad-clients
# stop all
$ ./bootstrap.sh --stop-consul
$ ./bootstrap.sh --stop-vault
$ ./bootstrap.sh --stop-nomad
$ ./bootstrap.sh --stop-nomad-clients
```

### External urls

* https://traefik.docker.localhost
* https://consul.docker.localhost
* https://nomad.docker.localhost
* https://vault.docker.localhost
* https://prometheus.docker.localhost
* https://grafana.docker.localhost

### Change logs

* https://github.com/hashicorp/nomad/blob/main/CHANGELOG.md
* https://github.com/hashicorp/consul/blob/main/CHANGELOG.md
* https://github.com/hashicorp/vault/blob/main/CHANGELOG.md