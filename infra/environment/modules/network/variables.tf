variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "management_subnet_name" {
  description = "Name of the management subnet"
  type        = string
}

variable "restricted_subnet_name" {
  description = "Name of the restricted subnet"
  type        = string
}

variable "management_subnet_cidr" {
  description = "CIDR block for management subnet"
  type        = string
}

variable "restricted_subnet_cidr" {
  description = "CIDR block for restricted subnet"
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