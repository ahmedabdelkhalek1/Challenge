provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "network" {
  source  = "./modules/network"
  project = var.project_id
  region  = var.region
}

module "firewall" {
  source  = "./modules/firewall"
  network = module.network.vpc_name
}

module "gke" {
  source       = "./modules/gke"
  project      = var.project_id
  region       = var.region
  vpc_id       = module.network.vpc_id
  subnet_id    = module.network.restricted_subnet_id
  node_count   = 3
  machine_type = "e2-medium"
}

module "bastion" {
  source    = "./modules/bastion"
  project   = var.project_id
  subnet_id = module.network.management_subnet_id
  zone      = var.zone
}

module "redis" {
  source      = "./modules/redis"
  project     = var.project_id
  region      = var.region
  memory_size = 1
}

resource "google_compute_global_address" "lb_ip" {
  name = "demo-app-lb-ip"
}

# Optional Secret Manager if secrets are needed
