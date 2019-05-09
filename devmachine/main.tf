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
  value = "${digitalocean_droplet.dev.ipv4_address}"
}

resource "digitalocean_droplet" "dev" {
  image = "debian-9-x64"
  name = "dev-${random_id.devmachine.b64_url}"
  region = "sfo2"
  size = "s-1vcpu-1gb"
  ssh_keys = [ "${data.digitalocean_ssh_key.work-laptop.fingerprint}" ]

  connection {
    type = "ssh"
    private_key = "${file("~/.ssh/id_rsa")}"
    user = "root"
    timeout = "2m"
  }
  provisioner "remote-exec" {
    script = "bootstrap.sh"

  }

  provisioner "file" {
    source = "secrets.sh"
    destination = "/mnt/secrets/secrets.sh"
  }

  provisioner "remote-exec" {
    inline = [ "chmod +x /mnt/secrets/secrets.sh" ]
  }
}

resource "digitalocean_firewall" "dev" {
  name = "dev"
  droplet_ids = [ "${digitalocean_droplet.dev.id}" ]
  outbound_rule = [
    { protocol = "tcp", port_range = "1-65535",
      destination_addresses = [ "0.0.0.0/0", "::/0"] },
    { protocol = "udp", port_range = "1-65535",
      destination_addresses = [ "0.0.0.0/0", "::/0"] },
    { protocol = "icmp", 
      destination_addresses = [ "0.0.0.0/0", "::/0"] },
  ]
}

output "fqdn" {
  value = "${digitalocean_record.dev.fqdn}"
}

# This is my default project currently, so everything will just get created here
# resource "digitalocean_project" "verda" {
#   name = "verda"
#   purpose = "Application and Development Support"
#   environment = "Development"
#   resources = [
#     "${digitalocean_droplet.dev.urn}"
#   ]
# }

