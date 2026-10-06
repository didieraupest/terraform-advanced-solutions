locals {
  required_apis = toset([
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "run.googleapis.com",
    "storage.googleapis.com",
    "serviceusage.googleapis.com",
  ])
  image_uri = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.images.repository_id}/${var.service_name}:${data.archive_file.source.output_md5}"
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/code"
  output_path = "${path.module}/.terraform/cloudrun-source.zip"
  excludes    = ["HelloWorldFunction/bin/**", "HelloWorldFunction/obj/**"]
}

resource "google_project_service" "required" {
  for_each           = local.required_apis
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "source" {
  name                        = "${var.project_id}-${var.service_name}-source"
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true

  depends_on = [google_project_service.required]
}

resource "google_artifact_registry_repository" "images" {
  project       = var.project_id
  location      = var.region
  repository_id = "${var.service_name}-images"
  description   = "Container images for ${var.service_name}."
  format        = "DOCKER"

  depends_on = [google_project_service.required]
}

resource "google_service_account" "builder" {
  project      = var.project_id
  account_id   = "${var.service_name}-builder"
  display_name = "Cloud Build account for ${var.service_name}"

  depends_on = [google_project_service.required]
}

resource "google_service_account" "runtime" {
  project      = var.project_id
  account_id   = "${var.service_name}-runtime"
  display_name = "Cloud Run runtime account for ${var.service_name}"

  depends_on = [google_project_service.required]
}

resource "google_project_service_identity" "cloudbuild" {
  provider = google-beta
  project  = var.project_id
  service  = "cloudbuild.googleapis.com"

  depends_on = [google_project_service.required]
}

resource "google_service_account_iam_member" "cloudbuild_use_builder" {
  service_account_id = google_service_account.builder.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_project_service_identity.cloudbuild.email}"
}

resource "google_storage_bucket_iam_member" "builder_staging_access" {
  bucket = google_storage_bucket.source.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.builder.email}"
}

resource "google_artifact_registry_repository_iam_member" "builder_image_writer" {
  project    = var.project_id
  location   = google_artifact_registry_repository.images.location
  repository = google_artifact_registry_repository.images.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.builder.email}"
}

resource "terraform_data" "build_image" {
  triggers_replace = [data.archive_file.source.output_md5]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "gcloud builds submit '${path.module}/code' --project='${var.project_id}' --region='${var.region}' --tag='${local.image_uri}' --service-account='projects/${var.project_id}/serviceAccounts/${google_service_account.builder.email}' --gcs-source-staging-dir='gs://${google_storage_bucket.source.name}/staging' --gcs-log-dir='gs://${google_storage_bucket.source.name}/logs'"
  }

  depends_on = [
    google_project_service.required,
    google_service_account_iam_member.cloudbuild_use_builder,
    google_storage_bucket_iam_member.builder_staging_access,
    google_artifact_registry_repository_iam_member.builder_image_writer,
  ]
}

resource "google_cloud_run_v2_service" "service" {
  project             = var.project_id
  name                = var.service_name
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    service_account = google_service_account.runtime.email
    timeout         = "60s"

    scaling {
      max_instance_count = 1
    }

    containers {
      image = local.image_uri

      ports {
        container_port = 8080
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "256Mi"
        }
      }
    }
  }

  depends_on = [terraform_data.build_image]
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = google_cloud_run_v2_service.service.location
  name     = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
