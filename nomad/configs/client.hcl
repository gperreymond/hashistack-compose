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
  http = "{{ GetInterfaceIP \"eth1\" }}"
  rpc  = "{{ GetInterfaceIP \"eth1\" }}"
  serf = "{{ GetInterfaceIP \"eth1\" }}"
}
bind_addr = "{{ GetInterfaceIP \"eth1\" }}"