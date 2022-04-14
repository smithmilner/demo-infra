data "digitalocean_loadbalancer" "prod_loadbalancer" {
  depends_on = [
    helm_release.ingress_nginx_chart
  ]

  name = "demo-prod-lb"
}

data "digitalocean_loadbalancer" "stage_loadbalancer" {
  name = "demo-stage-lb"
}

data "digitalocean_loadbalancer" "dev_loadbalancer" {
  name = "demo-dev-lb"
}

resource "digitalocean_domain" "default" {
  name = "smithmilner.com"
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "prod" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "@"
  value  = data.digitalocean_loadbalancer.prod_loadbalancer.ip
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
  value  = data.digitalocean_loadbalancer.prod_loadbalancer.ip
}

resource "digitalocean_record" "stage" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "stage"
  value  = data.digitalocean_loadbalancer.stage_loadbalancer.ip
}

resource "digitalocean_record" "dev" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "dev"
  value  = data.digitalocean_loadbalancer.dev_loadbalancer.ip
}
