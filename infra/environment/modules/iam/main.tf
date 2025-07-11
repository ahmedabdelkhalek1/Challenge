# Custom service account for GKE nodes
resource "google_service_account" "gke_service_account" {
  account_id   = "gke-nodes-sa"
  display_name = "GKE Nodes Service Account"
  description  = "Custom service account for GKE nodes"
}

# Required roles for GKE nodes
resource "google_project_iam_member" "gke_worker_node" {
  project = var.project_id
  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/artifactregistry.reader",
    "roles/compute.networkAdmin",
    "roles/compute.storageAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/compute.networkUser",
    "roles/iam.serviceAccountUser",
    "roles/storage.objectViewer"
  ])

  role   = each.value
  member = "serviceAccount:${google_service_account.gke_service_account.email}"
}

# Service account for VM
resource "google_service_account" "vm_service_account" {
  account_id   = "management-vm-sa"
  display_name = "Management VM Service Account"
  description  = "Service account for management VM"
}

# Required roles for management VM

resource "google_project_iam_member" "vm_service_account_roles" {
  project = var.project_id
  for_each = toset([
    "roles/container.developer",
    "roles/container.clusterAdmin",
    "roles/artifactregistry.admin",
    "roles/iam.serviceAccountUser"
  ])

  role   = each.value
  member = "serviceAccount:${google_service_account.vm_service_account.email}"
}


