resource "google_compute_instance" "bastion" {
  name         = "bastion-host"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250111"
    }
  }

  network_interface {
    subnetwork = var.subnet_id
  }

  tags = ["bastion"]

  metadata = {
    enable-oslogin = "TRUE"
  }
}