module "stage_cluster" {
  source       = "./modules/cluster"
  cluster_name = "${var.cluster_name}-stage"
  cluster_tags = ["stage"]
  providers = {
    digitalocean = digitalocean,
    kubernetes   = kubernetes.stage,
    helm         = helm.stage,
    kubectl      = kubectl.stage
  }
}
