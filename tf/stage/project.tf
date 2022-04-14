resource "digitalocean_project" "default_project" {
  name        = "${var.environment_name}-project"
  description = var.environment_description
  environment = var.environment_type
  resources = [
    digitalocean_kubernetes_cluster.default_cluster.urn,
  ]
}
