variable "project_id" {
  type        = string
}

variable "region" {
  type        = string
default     = "europe-west1"
}

variable "bucket_name" {
  type        = string
}

variable "database_name" {
  type        = string
 default     = "invoice"
}

variable "database_user" {
  type        = string
  default     = "invoice-app"
}

variable "database_password" {
  type        = string
  default     = ""
  sensitive   = true
}