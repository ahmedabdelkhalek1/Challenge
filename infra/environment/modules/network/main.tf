# VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Management Subnet (with NAT gateway)
resource "google_compute_subnetwork" "management" {
  name          = var.management_subnet_name
  ip_cidr_range = var.management_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  # Enable private Google access
  private_ip_google_access = true
}

# Restricted Subnet (no internet access)
resource "google_compute_subnetwork" "restricted" {
  name          = var.restricted_subnet_name
  ip_cidr_range = var.restricted_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  # Enable private Google access
  private_ip_google_access = true

  # Secondary IP ranges for GKE pods and services
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_service_networking_connection" "private_service_access" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["redis-range"]
}

# Cloud Router for NAT
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

# NAT Gateway for management subnet
resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  # Add NAT access for restricted subnet (needed for GKE)
  subnetwork {
    name                    = google_compute_subnetwork.restricted.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Firewall rule to allow IAP access to management subnet
resource "google_compute_firewall" "allow_iap" {
  name    = "${var.network_name}-allow-iap"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-access"]
  direction     = "INGRESS"
  priority      = 1000
}

# Allow Traffic from GKE nodes to management subnet
resource "google_compute_firewall" "allow_gke_to_management" {
  name    = "${var.network_name}-allow-gke-to-management"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = [google_compute_subnetwork.management.ip_cidr_range]
  target_tags   = ["gke-node"]
  direction     = "INGRESS"
  priority      = 500
}

# Allow traffic from management subnet to GKE master
resource "google_compute_firewall" "allow_management_to_gke_master" {
  name    = "allow-management-to-gke-master"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [google_compute_subnetwork.management.ip_cidr_range]
  direction     = "INGRESS"
  priority      = 1000
}