resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  }

  tags = ["bastion"]

  metadata = {
    enable-oslogin = "TRUE"
  }
}