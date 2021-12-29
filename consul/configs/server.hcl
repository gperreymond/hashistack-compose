datacenter = "europe-paris"
data_dir = "/opt/consul"
log_level  = "INFO"
log_json  = true
server    = true
bootstrap_expect = 3
retry_join = ["consul-server-1", "consul-server-2", "consul-server-3"]
telemetry = {
  prometheus_retention_time = "8h"
  disable_hostname = true
}
ui_config {
  enabled = true
}
encrypt_verify_incoming = true
encrypt_verify_outgoing = true
autopilot {
  cleanup_dead_servers = true
  last_contact_threshold = "1s"
  max_trailing_logs = 250
  server_stabilization_time = "10s"
}
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true
ca_file = "/home/root/certs/consul-agent-ca.pem"
cert_file = "/home/root/certs/europe-paris-server-consul-0.pem"
key_file = "/home/root/certs/europe-paris-server-consul-0-key.pem"
auto_encrypt {
  allow_tls = true
}
advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"