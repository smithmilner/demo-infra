
resource "digitalocean_kubernetes_cluster" "default_cluster" {
  name     = var.environment_name
  region   = var.region
  version  = "1.22.8-do.0"
  tags     = concat(var.cluster_tags, ["terraform"])
  vpc_uuid = digitalocean_vpc.default_vpc.id
  node_pool {
    name       = "${var.environment_name}-worker-pool"
    size       = var.default_node_size
    auto_scale = true
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
    labels     = {}
    tags       = concat(var.cluster_node_pool_tags, ["${var.environment_name}-worker"])
  }
  depends_on = [
    digitalocean_vpc.default_vpc
  ]
}

data "kubernetes_service" "load_balancer" {
  depends_on = [
    helm_release.ingress_nginx_chart
  ]
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

data "digitalocean_kubernetes_cluster" "dev_cluster" {
  name = "demo-dev"
}

data "digitalocean_kubernetes_cluster" "stage_cluster" {
  name = "demo-stage"
}
