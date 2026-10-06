output "service_url" {
  value       = google_cloud_run_v2_service.service.uri
  description = "Public HTTPS URL of the Cloud Run service."
}

output "container_image" {
  value       = local.image_uri
  description = "Container image deployed to Cloud Run."
}
