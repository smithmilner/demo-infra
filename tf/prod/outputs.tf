
output "cluster_id" {
  description = "ID of the kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster.id
}

output "cluster_status" {
  description = "Status of the kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster.status
}

output "external_ip" {
  description = "The dev cluster external IP"
  value       = data.kubernetes_service.load_balancer.status.0.load_balancer.0.ingress.0.ip
}
