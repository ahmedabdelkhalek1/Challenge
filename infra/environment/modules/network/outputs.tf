output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "management_subnet_name" {
  description = "Name of the management subnet"
  value       = google_compute_subnetwork.management.name
}

output "management_subnet_id" {
  description = "ID of the management subnet"
  value       = google_compute_subnetwork.management.id
}

output "restricted_subnet_name" {
  description = "Name of the restricted subnet"
  value       = google_compute_subnetwork.restricted.name
}

output "restricted_subnet_id" {
  description = "ID of the restricted subnet"
  value       = google_compute_subnetwork.restricted.id
}

output "router_name" {
  description = "Name of the Cloud Router"
  value       = google_compute_router.router.name
}

output "nat_name" {
  description = "Name of the NAT Gateway"
  value       = google_compute_router_nat.nat.name
} 