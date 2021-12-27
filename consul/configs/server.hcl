# ------------------
# DEFAULT
# ------------------
datacenter = "global"
data_dir = "/opt/consul"
log_level  = "INFO"
log_json  = true
server    = true
bootstrap_expect = 3
retry_join = ["consul-server-1", "consul-server-2", "consul-server-3"]
ui_config {
  enabled = true
}
autopilot {
  cleanup_dead_servers = true
  last_contact_threshold = "1s"
  max_trailing_logs = 250
  server_stabilization_time = "10s"
}
advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"