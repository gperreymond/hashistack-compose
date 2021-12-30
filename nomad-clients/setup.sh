#!/bin/bash
# Bootstrap machine

CONSUL_VERSION=1.11.1
NOMAD_VERSION=1.2.3

step=1
step() {
    echo "Step $step $1"
    step=$((step+1))
}

install_docker() {
    step "===== Installing docker ====="
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo usermod -aG docker vagrant
}

install_tools() {
    step "===== Installing tools ====="
    sudo apt install -y net-tools curl
    curl -sLS https://get.hashi-up.dev | sh
}

install_hashistack() {
    step "===== Installing hashistack ====="
    export $(xargs < /home/vagrant/localhost.env)
    echo "[INFO] CONSUL_ENCRYPT=${CONSUL_ENCRYPT}"
    echo "encrypt = \"${CONSUL_ENCRYPT}\"" | tee -a /home/vagrant/consul.hcl > /dev/null 
    hashi-up consul install --local --version ${CONSUL_VERSION} --config-file /home/vagrant/consul.hcl && \
    hashi-up nomad install --local --version ${NOMAD_VERSION} --config-file /home/vagrant/nomad.hcl
}

setup_welcome_msg() {
    sudo apt install -y cowsay
    sudo echo -e "\necho \"Welcome to Vagrant Ubuntu Server 20.04\" | cowsay\n" >> /home/vagrant/.bashrc
    sudo ln -s /usr/games/cowsay /usr/local/bin/cowsay
}

main() {
    install_tools
    install_docker
    install_hashistack
    setup_welcome_msg
}

main