module "prod_cluster" {
  source       = "./modules/cluster"
  cluster_name = "${var.cluster_name}-prod"
  providers = {
    digitalocean = digitalocean,
    kubernetes   = kubernetes.prod,
    helm         = helm.prod
  }
}

resource "helm_release" "argocd_chart" {
  provider         = helm.prod
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
}
