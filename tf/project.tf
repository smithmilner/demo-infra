resource "digitalocean_project" "default_project" {
  name        = "${var.cluster_name}-project"
  description = "Demo terraform project"
  resources = [
    module.dev_cluster.cluster.urn,
    module.stage_cluster.cluster.urn,
    module.prod_cluster.cluster.urn,
  ]

  depends_on = [
    module.dev_cluster.cluster,
    module.stage_cluster.cluster,
    module.prod_cluster.cluster,
  ]
}
