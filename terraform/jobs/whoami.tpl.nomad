job "whoami" {
  region      = "global"
  datacenters = ["europe-paris"]
  type = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "whoami" {
    count = 2

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    network {
      mode = "bridge"
      port "http" { to = 80 }
    }

    service {
      name = "whoami"
      port = "http"
      connect {
        sidecar_service {}
      }
    }
    
    task "whoami" {
      driver = "docker"
      config {
        image = "jwilder/whoami"
        ports = ["http"]
      }
      resources {
        cpu    = 5 
        memory = 10
      }
    }
  }
}