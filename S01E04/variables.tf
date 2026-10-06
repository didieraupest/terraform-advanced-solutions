variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "secret_value" {
  description = "Value of the application secret"
  type        = string
  sensitive   = true
}
