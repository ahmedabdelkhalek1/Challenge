resource "google_compute_network" "custom_vpc" {
  name                    = "custom-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "restricted" {
  name          = "restricted-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.custom_vpc.id
}

resource "google_compute_subnetwork" "management" {
  name          = "management-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.custom_vpc.id
}

output "vpc_id" {
  value = google_compute_network.custom_vpc.id
}

output "vpc_name" {
  value = google_compute_network.custom_vpc.name
}

output "restricted_subnet_id" {
  value = google_compute_subnetwork.restricted.id
}

output "management_subnet_id" {
  value = google_compute_subnetwork.management.id
}
