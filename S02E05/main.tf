module "backend" {
  source = "./modules/vm-template"
  template_name = "template-backend"
  vm_name       = "S02E05-Backend"
  datacenter_id     = data.vsphere_datacenter.dc.id
  resource_pool_id  = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore.id
  network_id        = data.vsphere_network.network.id

  folder   = var.vm_folder
  num_cpus = 2
  memory   = 2048

  extra_config = {
    "guestinfo.database.host" = module.postgresql.ip_address
  }
}

module "frontend" {
  source = "./modules/vm-template"
  template_name = "template-frontend"
  vm_name       = "S02E05-Frontend"

  datacenter_id     = data.vsphere_datacenter.dc.id
  resource_pool_id  = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore.id
  network_id        = data.vsphere_network.network.id

  folder   = var.vm_folder
  num_cpus = 1
  memory   = 1024
  extra_config = {
    "guestinfo.backend.host" = module.backend.ip_address
  }
}

module "postgresql" {
  source = "./modules/vm-template"

  template_name = "template-postgresql"
  vm_name       = "S02E05-PostgreSQL"

  datacenter_id     = data.vsphere_datacenter.dc.id
  resource_pool_id  = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore.id
  network_id        = data.vsphere_network.network.id

  folder   = var.vm_folder
  num_cpus = 2
  memory   = 2048
}
