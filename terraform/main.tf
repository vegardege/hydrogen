terraform {
  required_version = ">= 1.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

provider "hcloud" {
  # Token is read automatically from env var: HCLOUD_TOKEN
}

resource "hcloud_server" "server" {
  name        = var.server_name
  server_type = var.server_type
  image       = var.image
  location    = var.location
  ssh_keys    = [var.ssh_key_name]
}

resource "hcloud_firewall" "firewall" {
  name = "${var.server_name}-firewall"

  # SSH
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # HTTP
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # HTTPS
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # ICMP (ping)
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "firewall_attachment" {
  firewall_id = hcloud_firewall.firewall.id
  server_ids  = [hcloud_server.server.id]
}
