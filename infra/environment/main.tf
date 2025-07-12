terraform {
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Get GKE cluster info for Kubernetes provider
data "google_container_cluster" "primary" {
  name       = module.gke.cluster_name
  location   = var.cluster_location
  depends_on = [module.gke]
}

# Configure Kubernetes provider
provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

data "google_client_config" "default" {}

# Network module
module "network" {
  source = "./modules/network"

  project_id             = var.project_id
  region                 = var.region
  network_name           = var.network_name
  management_subnet_name = var.management_subnet_name
  restricted_subnet_name = var.restricted_subnet_name
  management_subnet_cidr = var.management_subnet_cidr
  restricted_subnet_cidr = var.restricted_subnet_cidr
  pods_cidr              = var.pods_cidr
  services_cidr          = var.services_cidr
}

# IAM module
module "iam" {
  source = "./modules/iam"

  project_id = var.project_id
}

# Artifact Registry module
module "artifact_registry" {
  source = "./modules/artifact-registry"

  project_id                = var.project_id
  region                    = var.region
  gke_service_account_email = module.iam.gke_service_account_email

  depends_on = [module.iam]
}

# Compute module (Private VM)
module "compute" {
  source = "./modules/compute"

  project_id               = var.project_id
  zone                     = var.zone
  region                   = var.region
  network_name             = module.network.network_name
  management_subnet_id     = module.network.management_subnet_id
  vm_machine_type          = var.vm_machine_type
  vm_service_account_email = module.iam.vm_service_account_email

  depends_on = [module.network, module.iam]
}

# GKE module
module "gke" {
  source = "./modules/gke"

  project_id             = var.project_id
  cluster_name           = var.cluster_name
  cluster_location       = var.cluster_location
  network_name           = module.network.network_name
  restricted_subnet_name = module.network.restricted_subnet_name
  pods_cidr              = var.pods_cidr
  services_cidr          = var.services_cidr
  master_cidr            = var.master_cidr
  management_subnet_cidr = var.management_subnet_cidr
  gke_machine_type       = var.gke_machine_type
  node_count             = var.node_count
  gke_service_account    = module.iam.gke_service_account_email

  depends_on = [module.network, module.iam]
}

module "redis" {
  source                 = "./modules/redis"
  project                = var.project_id
  region                 = var.region
  memory_size            = 1
  network_id             = module.network.network_id
  management_subnet_id   = module.network.management_subnet_id
  management_subnet_name = [module.network.management_subnet_name]
}