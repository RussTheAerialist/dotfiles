resource "random_id" "devmachine" {
  keepers = {
    host = "verda"
  }

  byte_length = 8
}

data "digitalocean_ssh_key" "work-laptop" {
  name = "work-laptop"
}

data "digitalocean_domain" "verda" {
  name = "verda.app"
}

resource "digitalocean_record" "dev" {
  domain = "${data.digitalocean_domain.verda.name}"
  type = "A"
  name = "dev-${random_id.devmachine.b64_url}"
  value = "127.0.0.1"
}

output "fqdn" {
  value = "${digitalocean_record.dev.fqdn}"
}
