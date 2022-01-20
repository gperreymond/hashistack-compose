datacenter = "europe-paris"
data_dir = "/opt/consul"
log_level  = "INFO"
log_json  = true
server    = true
encrypt = "IEU8KbUFLpSUZBtbz/4lA7NN/w17tAREwGh9MsMmktQ="
bootstrap_expect = 1
retry_join = ["192.168.50.101"]
telemetry {
  prometheus_retention_time = "8h"
  disable_hostname = true
}
ui_config {
  enabled = true
}
connect {
  enabled = true
}
ports {
  grpc = 8502
}
autopilot {
  cleanup_dead_servers = true
  last_contact_threshold = "1s"
  max_trailing_logs = 250
  server_stabilization_time = "10s"
}
verify_incoming = true
verify_incoming_rpc = true
verify_outgoing = true
verify_server_hostname = false
ca_file = "/home/vagrant/certs/consul-agent-ca.pem"
cert_file = "/home/vagrant/certs/europe-paris-server-consul-0.pem"
key_file = "/home/vagrant/certs/europe-paris-server-consul-0-key.pem"
auto_encrypt {
  allow_tls = true
}
advertise_addr = "{{ GetInterfaceIP \"eth1\" }}"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
