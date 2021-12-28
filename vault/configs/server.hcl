ui = "true"
cluster_name = "europe-paris"

storage "consul" {
  address = "consul-client-vault-server:8500"
  path    = "vault"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://{{ GetInterfaceIP \"eth0\" }}:8200"

cache {
  use_auto_auth_token = false
}
