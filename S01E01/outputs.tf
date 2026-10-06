
output "vm_names" {
  description = "Names of created VMs"
  value       = google_compute_instance.vm[*].name
}

output "vm_internal_ips" {
  description = "Internal IP addresses of created VMs"
  value       = google_compute_instance.vm[*].network_interface[0].network_ip
}

output "vm_external_ips" {
  description = "External IP addresses of created VMs"
  value = [
    for instance in google_compute_instance.vm :
    instance.network_interface[0].access_config[0].nat_ip
  ]
}