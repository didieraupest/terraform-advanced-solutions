output "id" {
  value = vsphere_virtual_machine.this.id
}

output "name" {
  value = vsphere_virtual_machine.this.name
}

output "ip_address" {
  value = vsphere_virtual_machine.this.default_ip_address
}
