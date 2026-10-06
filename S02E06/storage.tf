resource "google_storage_bucket" "invoice" {
  name     = "invoice-bucket"
  location = var.region
}
