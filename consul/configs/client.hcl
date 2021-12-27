# ------------------
# DEFAULT
# ------------------
datacenter = "global"
data_dir = "/opt/consul"
log_level  = "INFO"
log_json  = true
server    = false
retry_join = ["consul-server-1", "consul-server-2", "consul-server-3"]

advertise_addr = "{{ GetInterfaceIP \"eth0\" }}"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"