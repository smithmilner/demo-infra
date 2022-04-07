
resource "helm_release" "ingress_nginx_chart" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}
