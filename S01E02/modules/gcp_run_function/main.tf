
resource "google_project_service" "required" {
  for_each           = toset(local.required_apis)
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "function_sa" {
  account_id   = "${var.function_name}-sa"
  display_name = "Service account for ${var.function_name}"
  project      = var.project_id
  depends_on = [google_project_service.required]
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "gcp_run_function/function.zip"
}

resource "google_storage_bucket" "source_bucket" {
  name                        = local.bucket_name
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
  force_destroy               = true

  depends_on = [google_project_service.required]
}

resource "google_storage_bucket_object" "source_archive" {
  name   = "function-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.source_bucket.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions2_function" "function" {
  name     = var.function_name
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.source_bucket.name
        object = google_storage_bucket_object.source_archive.name
      }
    }
  }
 depends_on = [
    google_project_service.required,
    google_storage_bucket_object.source_archive
  ]

 service_config {
    max_instance_count    = 1
    available_memory      = "256M"
    timeout_seconds       = 60
    ingress_settings      = "ALLOW_ALL"
    service_account_email = google_service_account.function_sa.email
  }
}
resource "google_cloud_run_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = var.region
  service  = google_cloudfunctions2_function.function.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
