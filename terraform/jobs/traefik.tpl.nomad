job "traefik" {
  region      = "global"
  datacenters = ["europe-paris"]
  type        = "system"
  
  update {
    max_parallel = 1
    stagger = "1m"
    auto_revert = true
  }

  group "traefik" {
    network {
      port "http" {
        static = 80
      }
      port "https" {
        static = 443
      }
    }
    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v2.5.6"
        network_mode = "host"

        volumes = [
          "local/local-cert.pem:/etc/certs/local-cert.pem",
          "local/local-key.pem:/etc/certs/local-key.pem",
          "local/traefik.yaml:/etc/traefik/traefik.yaml",
          "local/dynamic_conf.yaml:/etc/traefik/dynamic_conf.yaml",
        ]
        ports = ["http", "https"]
      }

      template {
        data = <<EOF
${local_cert_pem}
EOF
        destination = "local/local-cert.pem"
      }

      template {
        data = <<EOF
${local_key_pem}
EOF
        destination = "local/local-key.pem"
      }

      template {
        data = <<EOF
${traefik_dynamic_conf}
EOF
        destination = "local/dynamic_conf.yaml"
      }

      template {
        data = <<EOF
${traefik_conf}
EOF
        destination = "local/traefik.yaml"
      }

      service {
        name = "traefik"
        port = "https"

        tags = [
          "traefik.enable=true",
          "traefik.http.routers.traefik.tls=true",
          "traefik.http.services.traefik.loadbalancer.server.port=8080",
        ]

        check {
          name     = "alive"
          type     = "http"
          port     = "http"
          path     = "/ping"
          interval = "5s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 256 # Mhz
        memory = 256 # MB
      }
    }
  }
}