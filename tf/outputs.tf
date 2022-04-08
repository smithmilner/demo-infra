
output "dev_cluster_id" {
  description = "ID of the kubernetes cluster"
  value       = module.dev_cluster.cluster.id
}

output "dev_cluster_status" {
  description = "Status of the kubernetes cluster"
  value       = module.dev_cluster.cluster.status
}

output "dev_external_ip" {
  description = "The dev cluster external IP"
  value       = module.dev_cluster.load_balancer_ip
}

output "stage_cluster_id" {
  description = "ID of the kubernetes cluster"
  value       = module.stage_cluster.cluster.id
}

output "stage_cluster_status" {
  description = "Status of the kubernetes cluster"
  value       = module.stage_cluster.cluster.status
}

output "stage_external_ip" {
  description = "The stage cluster external IP"
  value       = module.stage_cluster.load_balancer_ip
}

output "prod_cluster_id" {
  description = "ID of the kubernetes cluster"
  value       = module.prod_cluster.cluster.id
}

output "prod_cluster_status" {
  description = "Status of the kubernetes cluster"
  value       = module.prod_cluster.cluster.status
}

output "prod_external_ip" {
  description = "The production cluster external IP"
  value       = module.prod_cluster.load_balancer_ip
}

