
output "cluster" {
  description = "The kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster
}

output "cluster_tool_ingress" {
  description = "The ingress-nginx helm chart"
  value       = helm_release.ingress_nginx_chart
}

output "cluster_tool_cert_manager" {
  description = "The cert manager helm chart"
  value       = helm_release.cert_manager
}
output "load_balancer_ip" {
  description = "The load balancer provisioned for the kubernetes cluster"
  value       = data.kubernetes_service.load_balancer.status.0.load_balancer.0.ingress.0.ip
}
