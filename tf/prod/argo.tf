resource "helm_release" "argocd_chart" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
}

# Migrated from "kubernetes_manifest" to "kubectl_manifest" because
# kubernetes_manifest requires access to the control plane during
# terraforms plan phase which is impossible if we're also setting up the
# cluster in the same terraform process.
resource "kubectl_manifest" "argocd_ingress" {
  depends_on = [
    helm_release.ingress_nginx_chart
  ]

  wait_for_rollout = false

  yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: argocd
  name: argocd-ingress-service
  labels:
    name: argocd-ingress-service
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    cert-manager.io/cluster-issuer: letsencrypt-argocd
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - argocd.smithmilner.com
    secretName: argocd-tls
  rules:
  - host: argocd.smithmilner.com
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: argocd-server
            port:
              number: 443
YAML
}

resource "kubectl_manifest" "cert_issuer_argocd" {
  depends_on = [
    helm_release.cert_manager
  ]

  wait_for_rollout = false

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-argocd
spec:
  acme:
    email: smithmilner@gmail.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-private-key
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}


resource "kubectl_manifest" "application_prod" {
  depends_on = [
    helm_release.argocd_chart
  ]

  wait_for_rollout = false

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-prod
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/smithmilner/demo-infra.git
    targetRevision: HEAD
    path: k8s/overlays/prod
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}

resource "kubectl_manifest" "application_stage" {
  depends_on = [
    helm_release.argocd_chart
  ]

  wait_for_rollout = false

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-stage
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/smithmilner/demo-infra.git
    targetRevision: HEAD
    path: k8s/overlays/stage
  destination:
    server: ${data.digitalocean_kubernetes_cluster.stage_cluster.endpoint}
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}

resource "kubectl_manifest" "application_dev" {
  depends_on = [
    helm_release.argocd_chart
  ]

  wait_for_rollout = false

  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-dev
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/smithmilner/demo-infra.git
    targetRevision: HEAD
    path: k8s/overlays/dev
  destination:
    server: ${data.digitalocean_kubernetes_cluster.dev_cluster.endpoint}
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}

# Cluster secrets for DEV and STAGE are added to the production cluster.
# This allows argoCD running on the production cluster to deploy to dev and stage.

resource "kubernetes_secret" "stage_cluster" {
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
    server = data.digitalocean_kubernetes_cluster.stage_cluster.endpoint
    config = jsonencode({
      bearerToken = data.digitalocean_kubernetes_cluster.stage_cluster.kube_config[0].token
      tlsClientConfig = {
        insecure = false
        caData   = data.digitalocean_kubernetes_cluster.stage_cluster.kube_config[0].cluster_ca_certificate
      }
    })
  }
}

resource "kubernetes_secret" "dev_cluster" {
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
    server = data.digitalocean_kubernetes_cluster.dev_cluster.endpoint
    config = jsonencode({
      bearerToken = data.digitalocean_kubernetes_cluster.dev_cluster.kube_config[0].token
      tlsClientConfig = {
        insecure = false
        caData   = data.digitalocean_kubernetes_cluster.dev_cluster.kube_config[0].cluster_ca_certificate
      }
    })
  }
}
