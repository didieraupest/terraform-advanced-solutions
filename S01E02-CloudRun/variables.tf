variable "project_id" {
  type        = string
  description = "ID of the target GCP project."
}

variable "region" {
  type        = string
  description = "Region used for Cloud Run, Cloud Build, and Artifact Registry."
  default     = "europe-west1"
}

variable "service_name" {
  type        = string
  description = "Name of the Cloud Run service."
  default     = "hello-world-cloudrun"
}
