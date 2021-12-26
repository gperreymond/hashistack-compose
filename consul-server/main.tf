resource "random_uuid" "provisionning" {}


locals {
  consul_server_ips = split(", ", var.docker_ips)
}

resource "null_resource" "provisionning" {
  count = length(local.consul_server_ips)

  triggers = {
    uuid       = random_uuid.provisionning.result
    updated_at = timestamp()
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = "root"
    host     = local.consul_server_ips[count.index]
  }

  provisioner "remote-exec" {
    inline = [<<EOF
echo "[INFO] create configuration consul server for ip=${local.consul_server_ips[count.index]}"
mkdir /home/root
cat << EOT > /home/root/consul-server.hcl
# ------------------
# DEFAULT
# ------------------
datacenter = "global"
data_dir = "/opt/consul"
node_name = "consul-server-${local.consul_server_ips[count.index]}"
log_level  = "INFO"
log_json  = true
server    = true
bootstrap_expect = 3
retry_join = ["${join("\", \"", local.consul_server_ips)}"]
ui_config {
  enabled = true
}
autopilot {
  cleanup_dead_servers = true
  last_contact_threshold = "1s"
  max_trailing_logs = 250
  server_stabilization_time = "10s"
}
advertise_addr = "{{ GetInterfaceIP \"eth1\" }}"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
EOT
echo "[INFO] start consul server for ip=${local.consul_server_ips[count.index]}"
consul version
pkill -9 consul
consul agent -config-file=/home/root/consul-server.hcl </dev/null &>/dev/null &
sleep 10
EOF
    ]
  }
}