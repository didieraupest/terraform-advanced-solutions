terraform {
 required_version = ">= 1.16.0"
 required_providers {
   vsphere = {
      source = "vmware/vsphere"
      version = "~> 2.17"
   } 
 } 
}

provider "vsphere" { 
  user = "vsphereUser"
  password = "vspherePassword" 
  vsphere_server = "vsphereServer"
  allow_unverified_ssl = true
}
