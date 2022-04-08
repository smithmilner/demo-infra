terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "kubernetes" {
  alias = "dev"
  host  = module.dev_cluster.cluster.endpoint
  token = module.dev_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    module.dev_cluster.cluster.kube_config[0].cluster_ca_certificate
  )
}

# Dev providers
provider "helm" {
  alias = "dev"
  kubernetes {
    host  = module.dev_cluster.cluster.endpoint
    token = module.dev_cluster.cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      module.dev_cluster.cluster.kube_config[0].cluster_ca_certificate
    )
  }
}

provider "kubernetes" {
  alias = "stage"
  host  = module.stage_cluster.cluster.endpoint
  token = module.stage_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    module.stage_cluster.cluster.kube_config[0].cluster_ca_certificate
  )
}

# Stage providers
provider "helm" {
  alias = "stage"
  kubernetes {
    host  = module.stage_cluster.cluster.endpoint
    token = module.stage_cluster.cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      module.stage_cluster.cluster.kube_config[0].cluster_ca_certificate
    )
  }
}

# Prod providers
provider "kubernetes" {
  alias = "prod"
  host  = module.prod_cluster.cluster.endpoint
  token = module.prod_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    module.prod_cluster.cluster.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  alias = "prod"
  kubernetes {
    host  = module.prod_cluster.cluster.endpoint
    token = module.prod_cluster.cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      module.prod_cluster.cluster.kube_config[0].cluster_ca_certificate
    )
  }
}

provider "kubectl" {
  alias                  = "prod"
  host                   = module.prod_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(module.prod_cluster.cluster.kube_config[0].cluster_ca_certificate)
  token                  = module.prod_cluster.cluster.kube_config[0].token
  load_config_file       = false
}
