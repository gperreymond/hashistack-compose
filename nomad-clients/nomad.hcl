datacenter = "europe-paris"
data_dir = "/opt/nomad"
log_level  = "INFO"
log_json  = true
leave_on_interrupt = false
leave_on_terminate = true
consul {
  address = "127.0.0.1:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise = true
  server_auto_join = true
  client_auto_join = true
}
server {
  enabled = false
}
client {
  enabled = true
}
advertise {
  http = "172.0.10.201"
  rpc  = "172.0.10.201"
  serf = "172.0.10.201"
}
bind_addr = "172.0.10.201"
