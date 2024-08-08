terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.39.2"
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

resource "digitalocean_droplet" "ghost_server_4" {
  image             = "ubuntu-24-04-x64"
  name              = "ghost-server-4"
  region            = "tor1"
  size              = "s-1vcpu-1gb"
  monitoring        = true
  ssh_keys          = [var.ssh_key_id]
  tags              = ["blog", "ghost"]
  droplet_agent     = true
  graceful_shutdown = true
  backups           = false
}

resource "digitalocean_droplet" "ghost_db_1" {
  image             = "ubuntu-24-04-x64"
  name              = "ghost-db-1"
  region            = "tor1"
  size              = "s-1vcpu-1gb"
  monitoring        = true
  ssh_keys          = [var.ssh_key_id]
  tags              = ["blog", "ghost", "db"]
  droplet_agent     = true
  graceful_shutdown = true
  backups           = false
}

resource "digitalocean_monitor_alert" "cpu_alert" {
  alerts {
    email = [var.alert_email]
  }
  window  = "5m"
  type    = "v1/insights/droplet/cpu"
  compare = "GreaterThan"
  value   = 70
  enabled = true
  entities = [
    digitalocean_droplet.ghost_server_4.id,
    digitalocean_droplet.ghost_db_1.id
  ]
  description = "Alert about CPU usage"
}
