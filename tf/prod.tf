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

resource "helm_release" "argocd_chart" {
  provider         = helm.prod
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
}

resource "kubernetes_manifest" "application_prod" {
  provider = kubernetes.prod
  depends_on = [
    helm_release.argocd_chart
  ]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "demo-prod"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/smithmilner/demo-infra.git"
        targetRevision = "HEAD"
        path           = "k8s/overlays/prod"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}
