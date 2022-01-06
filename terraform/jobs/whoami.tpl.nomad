job "whoami" {
  region      = "global"
  datacenters = ["europe-paris"]
  type = "service"

  update {
    max_parallel = 1
    stagger = "1m"
    auto_revert = true
  }

  group "whoami" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    
    task "whoami" {
      driver = "docker"
      config {
        image = "jwilder/whoami"
        port_map {
          http = 8000
        }
      }
      resources {
        cpu    = 5 
        memory = 10
        network {
          port "http" {}
        }
      }
      service {
        name = "whoami"
        tags = [
          "traefik.frontend.rule=Host:hashi1.khazad-dum.tech",
          "traefik.frontend.entryPoints=http,https"
        ]
        port = "http"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}