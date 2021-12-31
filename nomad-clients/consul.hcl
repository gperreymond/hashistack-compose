datacenter = "europe-paris"
data_dir = "/opt/consul"
log_level  = "INFO"
log_json  = true
server    = false
retry_join = ["172.0.10.101", "172.0.10.102", "172.0.10.103"]
verify_incoming = true
verify_incoming_rpc = true
verify_outgoing = true
verify_server_hostname = false
ca_file = "/home/vagrant/certs/consul-agent-ca.pem"
auto_encrypt = {
  tls = true
}
advertise_addr = "{{ GetInterfaceIP \"eth1\" }}"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
