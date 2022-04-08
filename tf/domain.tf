resource "digitalocean_domain" "default" {
  name = "smithmilner.com"
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "prod" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "@"
  value  = module.prod_cluster.load_balancer_ip
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.default.id
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_record" "argocd" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "argocd"
  value  = module.prod_cluster.load_balancer_ip
}

resource "digitalocean_record" "stage" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "stage"
  value  = module.stage_cluster.load_balancer_ip
}

resource "digitalocean_record" "dev" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "dev"
  value  = module.dev_cluster.load_balancer_ip
}
