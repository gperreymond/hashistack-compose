# ------------------
# DEFAULT
# ------------------
datacenter = "global"
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
  enabled = true
  bootstrap_expect = 3
}
client {
  enabled = false
}
advertise {
  http = "{{ GetInterfaceIP \"eth0\" }}"
  rpc  = "{{ GetInterfaceIP \"eth0\" }}"
  serf = "{{ GetInterfaceIP \"eth0\" }}"
}
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
