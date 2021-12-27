* [x] Docker base image with consul, nomad and vault
* [x] Certificats with mkcert
* [x] Consul server
* [x] Nomad server with consul client
* [x] Nomad client with consul client


```sh
# Only one time
$ sudo apt install libnss3-tools # for mkcert
$ ./install-depencencies.sh
$ docker build -t hashistack-alpine:1.0.0 .
$ ./bootstrap.sh --generate-certificats
# Start and Stop the hashistack
$ ./bootstrap.sh --start
$ ./bootstrap.sh --stop
```
