output "vm_name" {
  description = "Name of the management VM"
  value       = google_compute_instance.management_vm.name
}

output "vm_internal_ip" {
  description = "Internal IP of the management VM"
  value       = google_compute_instance.management_vm.network_interface[0].network_ip
}

output "vm_zone" {
  description = "Zone of the management VM"
  value       = google_compute_instance.management_vm.zone
} 