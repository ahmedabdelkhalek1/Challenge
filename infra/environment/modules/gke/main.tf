resource "google_container_cluster" "private_gke" {
  name     = "private-gke-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  network    = var.vpc_id
  subnetwork = var.subnet_id
  ip_allocation_policy {}
}

resource "google_container_node_pool" "default_pool" {
  name       = "default-pool"
  cluster    = google_container_cluster.private_gke.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_type    = "pd-standard"
    disk_size_gb = 15
    tags         = ["gke-nodes"]
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
