datacenter = "europe-paris"
data_dir = "/opt/nomad"
log_level  = "INFO"
log_json  = true
leave_on_interrupt = false
leave_on_terminate = true
consul {
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
  http = "{{ GetInterfaceIP \"public-subnet\" }}"
  rpc  = "{{ GetInterfaceIP \"public-subnet\" }}"
  serf = "{{ GetInterfaceIP \"public-subnet\" }}"
}
bind_addr = "{{ GetInterfaceIP \"public-subnet\" }}"