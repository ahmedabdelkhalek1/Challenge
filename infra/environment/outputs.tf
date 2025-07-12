output "project_id" {
  description = "The GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "The GCP region"
  value       = var.region
}

output "vpc_network_name" {
  description = "Name of the VPC network"
  value       = module.network.network_name
}

output "management_vm_name" {
  description = "Name of the management VM"
  value       = module.compute.vm_name
}

output "management_vm_internal_ip" {
  description = "Internal IP of the management VM"
  value       = module.compute.vm_internal_ip
}

output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "gke_cluster_location" {
  description = "Location of the GKE cluster"
  value       = module.gke.cluster_location
}

output "artifact_registry_url" {
  description = "URL of the Artifact Registry repository"
  value       = module.artifact_registry.repository_url
}

output "gke_service_account_email" {
  description = "Email of the GKE service account"
  value       = module.iam.gke_service_account_email
}

output "redis_discovery_address" {
  description = "Network address of the exposed Redis discovery endpoint"
  value       = module.redis.redis_discovery_address
}

output "redis_discovery_port" {
  description = "Port number of the exposed Redis discovery endpoint"
  value       = module.redis.redis_discovery_port
}
