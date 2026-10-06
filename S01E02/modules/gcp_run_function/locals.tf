locals {
  required_apis = [
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "eventarc.googleapis.com",
    "storage.googleapis.com",
    "logging.googleapis.com"
  ]

  bucket_name = "${var.project_id}-${var.function_name}-src"
}
