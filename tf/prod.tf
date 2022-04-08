module "prod_cluster" {
  source       = "./modules/cluster"
  cluster_name = "${var.cluster_name}-prod"
  cluster_tags = ["prod"]
  providers = {
    digitalocean = digitalocean,
    kubernetes   = kubernetes.prod,
    helm         = helm.prod
  }
}
