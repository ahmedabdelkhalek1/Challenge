output "gke_service_account_email" {
  description = "Email of the GKE service account"
  value       = google_service_account.gke_service_account.email
}

output "vm_service_account_email" {
  description = "Email of the VM service account"
  value       = google_service_account.vm_service_account.email
} 