# Artifact Registry Repository
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "iti-docker-repo"
  description   = "Private Docker repository for ITI challenge"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}

# Repository IAM policy to allow GKE service account access
resource "google_artifact_registry_repository_iam_member" "gke_reader" {
  project    = var.project_id
  location   = google_artifact_registry_repository.docker_repo.location
  repository = google_artifact_registry_repository.docker_repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.gke_service_account_email}"
} 