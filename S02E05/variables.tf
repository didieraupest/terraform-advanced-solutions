variable "vsphere_user" {
 description = "vSphere username"
 type = string
 sensitive = true
} 

variable "vsphere_password" {
 description = "vSphere password"
 type = string
 sensitive = true
} 

variable "vsphere_server" {
 description = "vCenter server"
 type = string
} 

variable "datacenter" {
 description = "vSphere datacenter"
 type = string 
} 

variable "cluster" {
 description = "vSphere cluster"
 type = string
} 

variable "datastore" {
 description = "Datastore used for the VMs"
 type = string
} 

variable "network" {
 description = "VM network"
 type = string
} 

variable "vm_folder" {
 description = "Folder where application VMs are created"
 type = string
 default = ""
}
