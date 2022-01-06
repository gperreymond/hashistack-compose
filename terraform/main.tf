data "local_file" "traefik_conf" {
  filename = "${path.module}/jobs/traefik/traefik.yaml"
}

data "local_file" "traefik_dynamic_conf" {
  filename = "${path.module}/jobs/traefik/dynamic_conf.yaml"
}

data "local_file" "local_cert_pem" {
  filename = "${path.module}/../certs/local-cert.pem"
}

data "local_file" "local_key_pem" {
  filename = "${path.module}/../certs/local-key.pem"
}

// resource "nomad_job" "traefik" {
//   jobspec = templatefile("${path.module}/jobs/traefik.tpl.nomad", {
//     traefik_conf         = data.local_file.traefik_conf.content
//     traefik_dynamic_conf = data.local_file.traefik_dynamic_conf.content
//     local_cert_pem       = data.local_file.local_cert_pem.content
//     local_key_pem        = data.local_file.local_key_pem.content
//   })
// }

resource "nomad_job" "whoami" {
  jobspec = templatefile("${path.module}/jobs/whoami.tpl.nomad", {
  })
}