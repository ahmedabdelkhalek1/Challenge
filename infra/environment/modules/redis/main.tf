resource "google_redis_cluster" "cluster-ha" {
  name        = var.name
  shard_count = var.shard_count
  psc_configs {
    network = var.network_id
  }
  region        = var.region
  replica_count = var.replica_count
  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]
}

resource "google_network_connectivity_service_connection_policy" "default" {
  name          = "${var.name}-redis-cluster-connect"
  location      = var.region
  service_class = "gcp-memorystore-redis"
  description   = "Redis service connection policy"
  network       = var.network_id
  psc_config {
    subnetworks = var.management_subnet_id
  }
}
