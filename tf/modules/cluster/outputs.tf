
output "cluster" {
  description = "The kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster
}
