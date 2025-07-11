variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
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

variable "management_subnet_id" {
  description = "ID of the management subnet"
  type        = string
}

variable "vm_machine_type" {
  description = "Machine type for the VM"
  type        = string
}

variable "vm_service_account_email" {
  description = "Email of the VM service account"
  type        = string
} 