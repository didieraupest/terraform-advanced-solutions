resource "google_project_service" "secret_manager" { 
 project = var.project_id
 service = "secretmanager.googleapis.com"
 disable_on_destroy = false
}

resource "google_secret_manager_secret" "application_secret" {
 secret_id = "awesome-digital-invoice-secret"
 replication {
   auto {}
 }
}

resource "google_secret_manager_secret_version" "application_secret" {
  secret = google_secret_manager_secret.application_secret.id
  secret_data = var.secret_value
}
