# variable "digitalocean_token" {
#   description = "The API token from your Digital Ocean control panel"
#   type        = string
# }

variable "cluster_name" {
  description = "The name of the kubernetes cluster to create"
  type        = string
}

variable "region" {
  description = "The digital ocean region slug for where to create resources"
  type        = string
  default     = "tor1"
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
