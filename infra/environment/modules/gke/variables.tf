variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "cluster_location" {
  description = "Location of the GKE cluster"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "restricted_subnet_name" {
  description = "Name of the restricted subnet"
  type        = string
}

variable "pods_cidr" {
  description = "CIDR block for GKE pods"
  type        = string
}

variable "services_cidr" {
  description = "CIDR block for GKE services"
  type        = string
}

variable "master_cidr" {
  description = "CIDR block for GKE master"
  type        = string
}

variable "management_subnet_cidr" {
  description = "CIDR block for management subnet"
  type        = string
}

variable "gke_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the GKE cluster"
  type        = number
}

variable "gke_service_account" {
  description = "Service account email for GKE nodes"
  type        = string
} 