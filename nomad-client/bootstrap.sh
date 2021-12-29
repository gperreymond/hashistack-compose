#!/bin/bash
# Bootstrap machine

CONSUL_VERSION=1.11.1
NOMAD_VERSION=1.2.3
VAULT_VERSION=1.9.2

ensure_netplan_apply() {
    # First node up assign dhcp IP for eth1, not base on netplan yml
    sleep 5
    sudo netplan apply
}

step=1
step() {
    echo "Step $step $1"
    step=$((step+1))
}

# resolve_dns() {
#     step "===== Create symlink to /run/systemd/resolve/resolv.conf ====="
#     sudo rm /etc/resolv.conf
#     sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
# }

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

install_openssh() {
    step "===== Installing openssh ====="
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt install -y openssh-server
    sudo systemctl enable ssh
}

install_tools() {
    step "===== Installing tools ====="
    sudo apt install -y net-tools curl
    curl -sLS https://get.hashi-up.dev | sh && \
    hashi-up consul get --version ${CONSUL_VERSION} && \
    hashi-up nomad get --version ${NOMAD_VERSION} && \
    hashi-up vault get --version ${VAULT_VERSION}
}

setup_root_login() {
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
    sudo echo "root:rootroot" | chpasswd
}

setup_welcome_msg() {
    sudo apt install -y cowsay
    sudo echo -e "\necho \"Welcome to Vagrant Ubuntu Server 20.04\" | cowsay\n" >> /home/vagrant/.bashrc
    sudo ln -s /usr/games/cowsay /usr/local/bin/cowsay
}

main() {
    ensure_netplan_apply
    # resolve_dns
    install_tools
    install_openssh
    install_docker
    setup_root_login
    setup_welcome_msg
}

main