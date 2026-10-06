variable "project_id" {
  type        = string
  description = "ID of the target GCP Project"
}

variable "region" {
  type        = string
  description = "Deployment region"
  default     = "europe-west1"
}

variable "function_name" {
  type        = string
  description = "Cloud Function name"
  default     = "training-function"
}

variable "entry_point" {
  type        = string
  description = "Provided by the developer"
}
