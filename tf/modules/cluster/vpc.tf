resource "digitalocean_vpc" "default_vpc" {
  name   = "${var.cluster_name}-network"
  region = var.region

  timeouts {
    delete = "10m"
  }
}
