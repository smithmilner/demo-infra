# Cluster secrets for DEV and STAGE are added to the production cluster.
# This allows argoCD running on the production cluster to deploy to dev and stage.

resource "kubernetes_secret" "dev_cluster" {
  provider = kubernetes.prod
  depends_on = [
    helm_release.argocd_chart
  ]
  metadata {
    namespace   = "argocd"
    name        = "demo-dev-secret"
    annotations = {}
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }
  type = "Opaque"
  data = {
    name   = "demo-dev"
    server = module.dev_cluster.cluster.endpoint
    config = jsonencode({
      bearerToken = module.dev_cluster.cluster.kube_config[0].token
      tlsClientConfig = {
        insecure = false
        caData   = module.dev_cluster.cluster.kube_config[0].cluster_ca_certificate
      }
    })
  }
}

resource "kubernetes_secret" "stage_cluster" {
  provider = kubernetes.prod
  depends_on = [
    helm_release.argocd_chart
  ]
  metadata {
    namespace   = "argocd"
    name        = "demo-stage-secret"
    annotations = {}
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }
  type = "Opaque"
  data = {
    name   = "demo-stage"
    server = module.stage_cluster.cluster.endpoint
    config = jsonencode({
      bearerToken = module.stage_cluster.cluster.kube_config[0].token
      tlsClientConfig = {
        insecure = false
        caData   = module.stage_cluster.cluster.kube_config[0].cluster_ca_certificate
      }
    })
  }
}
