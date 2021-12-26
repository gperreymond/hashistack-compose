FROM ubuntu:20.04

ENV CONSUL_VERSION=1.11.1 \
    NOMAD_VERSION=1.2.3 \
    VAULT_VERSION=1.9.2

# PREPARE
RUN apt update && \
    apt install -y libcap2-bin iproute2

# HASHIUP
RUN apt update && \
    apt install -y curl && \
    curl -sLS https://get.hashi-up.dev | sh && \
    hashi-up consul install --local --version ${CONSUL_VERSION} --skip-enable && \
    hashi-up nomad install --local --version ${NOMAD_VERSION} --skip-enable && \
    hashi-up vault install --local --version ${VAULT_VERSION} --skip-enable

EXPOSE 8500 8600 8600/udp 8300 8301 8301/udp 8302 8302/udp
EXPOSE 4646 4647 4648 4648/udp
EXPOSE 8200

# CLEN IMAGE
RUN apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
