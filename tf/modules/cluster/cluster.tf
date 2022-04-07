
resource "digitalocean_kubernetes_cluster" "default_cluster" {
  name     = var.cluster_name
  region   = var.region
  version  = "1.22.7-do.0"
  tags     = concat(var.cluster_tags, ["terraform"])
  vpc_uuid = digitalocean_vpc.default_vpc.id
  node_pool {
    name       = "${var.cluster_name}-worker-pool"
    size       = var.default_node_size
    auto_scale = true
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
    labels     = {}
    tags       = concat(var.cluster_node_pool_tags, ["${var.cluster_name}-worker"])
  }
  depends_on = [
    digitalocean_vpc.default_vpc
  ]
}
