# Create VPC Network
resource "google_compute_network" "consumer_net" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

# Create Subnet
resource "google_compute_subnetwork" "consumer_subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.248/29"
  region        = var.region
  network       = google_compute_network.consumer_net.id
}

# PSC Service Connection Policy for Memorystore
resource "google_network_connectivity_service_connection_policy" "default" {
  name          = "my-policy"
  location      = var.region
  service_class = "gcp-memorystore-redis"
  description   = "my basic service connection policy"
  network       = google_compute_network.consumer_net.id

  psc_config {
    subnetworks = [google_compute_subnetwork.consumer_subnet.id]
  }
}

# Redis Cluster Resource
resource "google_redis_cluster" "redis_cluster" {
  name                        = "ha-cluster"
  region                      = var.region
  shard_count                 = 3
  replica_count               = 1
  node_type                   = "REDIS_SHARED_CORE_NANO" # change to a higher tier if needed
  transit_encryption_mode     = "TRANSIT_ENCRYPTION_MODE_DISABLED"
  authorization_mode          = "AUTH_MODE_DISABLED"
  deletion_protection_enabled = true

  redis_configs = {
    maxmemory-policy = "volatile-ttl"
  }

  zone_distribution_config {
    mode = "MULTI_ZONE"
  }

  psc_configs {
    network = google_compute_network.consumer_net.id
  }

  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]
}

# Outputs
output "redis_cluster_host" {
  value = google_redis_cluster.redis_cluster.nodes[0].ip
}

output "redis_cluster_port" {
  value = 6379
}
