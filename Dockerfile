FROM ubuntu:20.04

ENV CONSUL_VERSION=1.11.1 \
    NOMAD_VERSION=1.2.3 \
    VAULT_VERSION=1.9.2

# PREPARE
RUN apt update && \
    apt install -y libcap2-bin curl

# HASHIUP
RUN curl -sLS https://get.hashi-up.dev | sh && \
    hashi-up consul get --version ${CONSUL_VERSION} && \
    hashi-up nomad get --version ${NOMAD_VERSION} && \
    hashi-up vault get --version ${VAULT_VERSION}

EXPOSE 8500 8600 8600/udp 8300 8301 8301/udp 8302 8302/udp
EXPOSE 4646 4647 4648 4648/udp
EXPOSE 8200

# CLEAN IMAGE
RUN apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
