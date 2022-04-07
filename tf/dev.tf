module "dev_cluster" {
  source       = "./modules/cluster"
  cluster_name = "${var.cluster_name}-dev"
  providers = {
    digitalocean = digitalocean,
    kubernetes   = kubernetes.dev,
    helm         = helm.dev
  }
}
