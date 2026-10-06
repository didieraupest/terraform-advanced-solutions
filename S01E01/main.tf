variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-west1-b"
}

variable "network_name" {
  description = "Name of the existing VPC network"
  type        = string
}

variable "subnetwork_name" {
  description = "Name of the existing subnet"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VMs"
  type        = string
  default     = "e2-medium"
}

variable "instance_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}

variable "instance_names" {
  description = "Names of the VMs"
  type        = list(string)
  default     = ["vm-1", "vm-2", "vm-3"]
}

resource "google_compute_instance" "vm" {
  count        = var.instance_count
  name         = var.instance_names[count.index]
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["terraform", "exercise"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = data.google_compute_network.existing_vpc.id
    subnetwork = data.google_compute_subnetwork.existing_subnet.id

    access_config {}
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}