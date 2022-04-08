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
  # depends_on = [
  #   helm_release.argocd_chart
  # ]
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

resource "kubernetes_manifest" "application_stage" {
  provider = kubernetes.prod
  # depends_on = [
  #   helm_release.argocd_chart
  # ]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "demo-stage"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/smithmilner/demo-infra.git"
        targetRevision = "HEAD"
        path           = "k8s/overlays/stage"
      }
      destination = {
        server    = module.stage_cluster.cluster.endpoint
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

resource "kubernetes_manifest" "application_dev" {
  provider = kubernetes.prod
  # depends_on = [
  #   helm_release.argocd_chart
  # ]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "demo-dev"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/smithmilner/demo-infra.git"
        targetRevision = "HEAD"
        path           = "k8s/overlays/dev"
      }
      destination = {
        server    = module.dev_cluster.cluster.endpoint
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
