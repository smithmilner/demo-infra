resource "digitalocean_vpc" "default_vpc" {
  name   = "${var.environment_name}-network"
  region = var.region

  # Increase timeout because k8s clusters take a long time to destroy.
  timeouts {
    delete = "10m"
  }
}
