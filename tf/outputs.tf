
output "dev_cluster_id" {
  description = "ID of the kubernetes cluster"
  value       = module.dev_cluster.cluster.id
}

output "dev_cluster_status" {
  description = "Status of the kubernetes cluster"
  value       = module.dev_cluster.cluster.status
}

output "stage_cluster_id" {
  description = "ID of the kubernetes cluster"
  value       = module.stage_cluster.cluster.id
}

output "stage_cluster_status" {
  description = "Status of the kubernetes cluster"
  value       = module.stage_cluster.cluster.status
}

output "prod_cluster_id" {
  description = "ID of the kubernetes cluster"
  value       = module.prod_cluster.cluster.id
}

output "prod_cluster_status" {
  description = "Status of the kubernetes cluster"
  value       = module.prod_cluster.cluster.status
}

