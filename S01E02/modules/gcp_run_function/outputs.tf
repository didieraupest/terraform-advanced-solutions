output "function_url" {
 value = google_cloudfunctions2_function.function.url
 description = "HTTP URL of the function"
 type = string
}

output "function_sa" {
  value       = google_service_account.function_sa
  description = "The service account used by the function"
  type        = object({
    email = string
  })
}