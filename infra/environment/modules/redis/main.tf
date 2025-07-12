resource "google_redis_cluster" "cluster-ha" {
  name        = var.name
  shard_count = var.shard_count
  psc_configs {
    network = var.network_id
  }
  region        = var.region
  replica_count = var.replica_count


}



