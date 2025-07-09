output "vpc_id" {
  value = google_compute_network.custom_vpc.id
}
output "restricted_subnet_id" {
  value = google_compute_subnetwork.restricted.id
}
output "management_subnet_id" {
  value = google_compute_subnetwork.management.id
}