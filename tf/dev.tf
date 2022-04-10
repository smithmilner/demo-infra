module "dev_cluster" {
  source       = "./modules/cluster"
  cluster_name = "${var.cluster_name}-dev"
  cluster_tags = ["dev"]
  providers = {
    digitalocean = digitalocean,
    kubernetes   = kubernetes.dev,
    helm         = helm.dev,
    kubectl      = kubectl.dev
  }
}
