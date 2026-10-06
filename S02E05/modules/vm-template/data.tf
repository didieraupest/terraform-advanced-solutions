data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = var.datacenter_id
}
