resource "helm_release" "argocd_chart" {
  provider         = helm.prod
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"

  depends_on = [
    module.prod_cluster.cluster
  ]
}

# Migrated from "kubernetes_manifest" to "kubectl_manifest" because
# kubernetes_manifest requires access to the control plane during
# terraforms plan phase which is impossible if we're also setting up the
# cluster in the same terraform process.
resource "kubectl_manifest" "argocd_ingress" {
  provider = kubectl.prod
  depends_on = [
    module.prod_cluster.cluster_tool_ingress
  ]

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
    cert-manager.io/cluster-issuer: letsencrypt
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

resource "kubectl_manifest" "application_prod" {
  provider = kubectl.prod
  depends_on = [
    helm_release.argocd_chart
  ]

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
  provider = kubectl.prod
  depends_on = [
    helm_release.argocd_chart
  ]

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
    server: ${module.stage_cluster.cluster.endpoint}
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}

resource "kubectl_manifest" "application_dev" {
  provider = kubectl.prod
  depends_on = [
    helm_release.argocd_chart
  ]

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
    server: ${module.dev_cluster.cluster.endpoint}
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML
}
