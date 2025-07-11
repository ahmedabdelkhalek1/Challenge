# Private VM in management subnet
resource "google_compute_instance" "management_vm" {
  name         = "management-vm"
  machine_type = var.vm_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20250111"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = var.management_subnet_id
    # No external IP - private VM
  }

  # IAP access tag
  tags = ["iap-access"]

  service_account {
    email  = var.vm_service_account_email
    scopes = ["cloud-platform"]
  }

  # Startup script to install necessary tools
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt update
    sudo apt install -y docker.io git
    
    # Add user to docker group
    usermod -aG docker $USER

    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
    chmod +x kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    
    # Install gcloud CLI
    curl https://sdk.cloud.google.com | bash
    exec -l $SHELL
    
    # Configure Docker for Artifact Registry
    gcloud auth configure-docker ${var.region}-docker.pkg.dev
    
    # Install kubectl gke-gcloud-auth-plugin
    gcloud components install gke-gcloud-auth-plugin
  EOT

} 