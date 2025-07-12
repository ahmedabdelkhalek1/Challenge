output "redis_discovery_address" {
  description = "Network address of the exposed Redis discovery endpoint"
  value       = google_redis_cluster.cluster-ha.discovery_endpoints[0].address
}

output "redis_discovery_port" {
  description = "Port number of the exposed Redis discovery endpoint"
  value       = google_redis_cluster.cluster-ha.discovery_endpoints[0].port
}
