resource "google_storage_bucket_iam_member" "function_storage_write" {
  bucket = google_storage_bucket.invoice.name
  role   = "roles/storage.objectCreator"

  member = "serviceAccount:${module.gcp_run_function.function_sa.email}"
}

resource "google_project_iam_member" "function_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"

  member = "serviceAccount:${module.gcp_run_function.function_sa.email}"
}

resource "google_secret_manager_secret_iam_member" "function_secret_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.application.secret_id
  role      = "roles/secretmanager.secretAccessor"

  member = "serviceAccount:${module.gcp_run_function.function_sa.email}"
}
