resource "google_secret_manager_secret" "application" {
  secret_id = "awesome-digital-invoice-secret"

  replication {
    auto {}
  }

  depends_on = [
    google_project_service.required
  ]
}
