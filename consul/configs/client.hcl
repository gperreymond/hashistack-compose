datacenter = "europe-paris"
data_dir = "/opt/consul"
log_level  = "INFO"
log_json  = true
server    = false
retry_join = ["consul-server-1", "consul-server-2", "consul-server-3"]
verify_incoming = false
verify_outgoing = true
verify_server_hostname = true
ca_file = "/home/root/certs/consul-agent-ca.pem"
auto_encrypt = {
  tls = true
}
advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"