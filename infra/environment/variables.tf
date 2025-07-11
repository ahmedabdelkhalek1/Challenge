variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "artful-fragment-458014-j4"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "private-cluster"
}

variable "cluster_location" {
  description = "Location of the GKE cluster"
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "custom-vpc"
}

variable "management_subnet_name" {
  description = "Name of the management subnet"
  type        = string
  default     = "management-subnet"
}

variable "restricted_subnet_name" {
  description = "Name of the restricted subnet"
  type        = string
  default     = "restricted-subnet"
}

variable "management_subnet_cidr" {
  description = "CIDR block for management subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "restricted_subnet_cidr" {
  description = "CIDR block for restricted subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "pods_cidr" {
  description = "CIDR block for GKE pods"
  type        = string
  default     = "10.1.0.0/16"
}

variable "services_cidr" {
  description = "CIDR block for GKE services"
  type        = string
  default     = "10.2.0.0/16"
}

variable "master_cidr" {
  description = "CIDR block for GKE master"
  type        = string
  default     = "172.16.0.0/28"
}

variable "vm_machine_type" {
  description = "Machine type for the private VM"
  type        = string
  default     = "e2-micro"
}

variable "gke_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_count" {
  description = "Number of nodes in the GKE cluster"
  type        = number
  default     = 2
} 