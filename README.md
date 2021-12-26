* [x] Docker base image with ssh open
* [x] Terraform for provisionning
* [x] Consul server


```sh
$ ./install-depencencies.sh
$ docker build -t hashistack-alpine:1.0.0 .
$ ./bootstrap.sh --start
$ ./bootstrap.sh --start-consul-server
$ ./bootstrap.sh --stop
```
