# ------------------
# DEFAULT
# ------------------
datacenter = "global"
data_dir = "/opt/consul"
log_level  = "INFO"
log_json  = true
server    = false
retry_join = ["consul-server-1", "consul-server-2", "consul-server-3"]
bind_addr = "{{ GetInterfaceIP \"eth0\" }}"
client_addr = "{{ GetInterfaceIP \"eth0\" }}" # Because not on the same physical machine "127.0.0.1"