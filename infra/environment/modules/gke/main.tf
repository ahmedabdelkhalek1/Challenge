# Private GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location

  # Network configuration
  network    = var.network_name
  subnetwork = var.restricted_subnet_name

  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Disable deletion protection to allow cluster destruction
  deletion_protection = false

  # Private cluster configuration
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_cidr
  }

  # Enable access from management subnet only
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.management_subnet_cidr
      display_name = "management-subnet"
    }
  }

  # IP allocation policy for secondary ranges
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

}

# Node pool with custom service account
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  # Autoscaling
  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  # Node configuration
  node_config {
    preemptible  = false
    machine_type = var.gke_machine_type

    service_account = var.gke_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    # Network tags
    tags = ["no-internet", "gke-node", "allow-health-checks"]

  }

  # Management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
} 