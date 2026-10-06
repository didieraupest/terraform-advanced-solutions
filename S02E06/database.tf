resource "google_sql_database_instance" "invoice" {
  name             = "awesome-digital-invoice-db"
  database_version = "POSTGRES_15"
  region           = var.region
  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    backup_configuration {
      enabled = false
    }
    ip_configuration {
      ipv4_enabled = true
    }
  }
  deletion_protection = false
  depends_on = [
    google_project_service.required
  ]
}

resource "google_sql_database" "invoice" {
  name     = var.database_name
  instance = google_sql_database_instance.invoice.name
}

resource "google_sql_user" "invoice" {
  name     = var.database_user
  instance = google_sql_database_instance.invoice.name

  password = var.database_password
}