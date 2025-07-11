variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "gke_service_account_email" {
  description = "Email of the GKE service account"
  type        = string
} 