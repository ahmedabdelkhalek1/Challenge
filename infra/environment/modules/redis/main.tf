resource "google_redis_instance" "redis" {
  name              = "demo-redis"
  tier              = "STANDARD_HA"
  memory_size_gb    = var.memory_size
  region            = var.region
  authorized_network = "projects/${var.project}/global/networks/custom-vpc"
}

output "redis_host" {
  value = google_redis_instance.redis.host
}

output "redis_port" {
  value = google_redis_instance.redis.port
}