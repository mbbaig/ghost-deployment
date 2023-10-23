terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.29.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {
  type = string
}

variable "ssh_key_id" {
  type = number
}

variable "alert_email" {
  type = string
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "ghost_server_2" {
  image  = "ubuntu-20-04-x64"
  name   = "ghost-server-2"
  region = "tor1"
  size   = "s-1vcpu-2gb"
  monitoring = true
  ssh_keys = [var.ssh_key_id]
  tags = ["blog", "ghost"]
  droplet_agent = true
  graceful_shutdown = true
  backups = true
}

resource "digitalocean_droplet" "ghost_server_3" {
  image  = "fedora-38-x64"
  name   = "ghost-server-3"
  region = "tor1"
  size   = "s-1vcpu-2gb"
  monitoring = true
  ssh_keys = [var.ssh_key_id]
  tags = ["blog", "ghost"]
  droplet_agent = true
  graceful_shutdown = true
  backups = false
}

resource "digitalocean_monitor_alert" "cpu_alert" {
  alerts {
    email = [var.alert_email]
  }
  window      = "5m"
  type        = "v1/insights/droplet/cpu"
  compare     = "GreaterThan"
  value       = 70
  enabled     = true
  entities    = [digitalocean_droplet.ghost_server_3.id]
  description = "Alert about CPU usage"
}
