module "stage_cluster" {
  source       = "./modules/cluster"
  cluster_name = "${var.cluster_name}-stage"
  providers = {
    digitalocean = digitalocean,
    kubernetes   = kubernetes.stage,
    helm         = helm.stage
  }
}
