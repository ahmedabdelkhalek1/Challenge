resource "google_compute_firewall" "allow_ssh_bastion" {
  name    = "allow-ssh-bastion"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["X.X.X.X/32"]
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "allow_bastion_to_gke" {
  name    = "allow-bastion-to-gke"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["443","6443"]
  }

  source_tags = ["bastion"]
  target_tags = ["gke-nodes"]
}
