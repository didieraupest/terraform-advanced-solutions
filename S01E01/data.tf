data "google_compute_network" "existing_vpc" {
  name = var.network_name
}

data "google_compute_subnetwork" "existing_subnet" {
  name   = var.subnetwork_name
  region = var.region
}
