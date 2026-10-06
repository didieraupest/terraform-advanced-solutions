variable "template_name" {
 type        = string
}
variable "vm_name" {
 type        = string
}
variable "datacenter_id" {
 type        = string
}
variable "resource_pool_id" {
 type        = string
}
variable "datastore_id" {
 type        = string
}
variable "network_id" {
 type        = string
}
variable "folder" {
 type        = string
 default     = null
}
variable "num_cpus" {
 type        = number
 default     = 2
}
variable "memory" {
 type        = number
 default     = 2048
}
variable "extra_config" {
 type        = map(string)
 default     = {}
}
