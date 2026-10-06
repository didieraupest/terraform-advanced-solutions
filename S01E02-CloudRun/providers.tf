terraform {
  required_version = ">= 1.16.0"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.8"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 8.0"
    }
  }
}

provider "google" {
  project = "op-nz9t"
  region  = "europe-west9"
  zone    = "europe-west9-a"
}

provider "google-beta" {
  project = "op-nz9t"
  region  = "europe-west9"
  zone    = "europe-west9-a"
}
