terraform {
  required_version = ">= 1.16.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}
provider "google" {
  project = "op-nz9t"
  region  = "europe-west9"
  zone    = "europe-west9-a"
}
