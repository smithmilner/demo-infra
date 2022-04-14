# variable "digitalocean_token" {
#   description = "The API token from your Digital Ocean control panel"
#   type        = string
# }

variable "environment_name" {
  description = "The name of the environment to create. Must be snake case eg. demo-dev"
  type        = string
}

variable "environment_type" {
  description = "The project environment. Valid options are Development, Staging, Production."
  type        = string
}

variable "environment_description" {
  description = "The project description."
  type        = string
  default     = "Terraform project"
}

variable "region" {
  description = "The digital ocean region slug for where to create resources"
  type        = string
  default     = "tor1"
}

variable "cluster_tags" {
  description = "The tags applied to the cluster"
  type        = list(string)
  default     = []
}

variable "cluster_node_pool_tags" {
  description = "The tags applied to the cluster's node pool"
  type        = list(string)
  default     = []
}
variable "min_nodes" {
  description = "The minimum number of nodes in the default pool"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "The maximum number of nodes in the default pool"
  type        = number
  default     = 5
}

variable "default_node_size" {
  description = "The default digital ocean node slug for each node in the default pool"
  type        = string
  default     = "s-1vcpu-2gb"
}
