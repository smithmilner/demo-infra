
output "cluster" {
  description = "The kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster
}

output "load_balancer_ip" {
  description = "The load balancer provisioned for the kubernetes cluster"
  value       = data.kubernetes_service.load_balancer.status.0.load_balancer.0.ingress.0.ip
}
