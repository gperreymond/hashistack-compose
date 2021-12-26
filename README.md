* [x] Docker base image with ssh open
* [x] Certificats with mkcert
* [x] Terraform for provisionning
* [x] Consul server


```sh
# Only one time
$ sudo apt install libnss3-tools # for mkcert
$ ./install-depencencies.sh
$ docker build -t hashistack-alpine:1.0.0 .
$ ./bootstrap.sh --generate-certificats
# Start and Stop the hashistack
$ ./bootstrap.sh --start
$ ./bootstrap.sh --start-consul-server
$ ./bootstrap.sh --stop
```
