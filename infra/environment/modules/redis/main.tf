resource "google_service_networking_connection" "private_service_access" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["redis-range"]
}
resource "google_redis_instance" "redis" {
  name               = "demo-redis"
  tier               = "STANDARD_HA"
  memory_size_gb     = var.memory_size
  region             = var.region
  authorized_network = "projects/${var.project}/global/networks/custom-vpc"
  reserved_ip_range  = google_service_networking_connection.private_service_access.reserved_peering_ranges[0]
}

output "redis_host" {
  value = google_redis_instance.redis.host
}

output "redis_port" {
  value = google_redis_instance.redis.port
}