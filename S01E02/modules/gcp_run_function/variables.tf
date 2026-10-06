
variable "project_id" { 
  type=string
  description="ID of the target GCP Project"
} 

variable "region" { 
  type=string
  description="Deployment region"
}

variable "function_name" {
  type=string
  description="Name of the Cloud Function"
}

variable "entry_point" { 
  type=string
  description="Entry point of the Cloud Function"
}

variable "runtime" {
  type=string
  description="Runtime type: check doc"
}

variable "source_dir" {
  type=string
  description="path of the zip archive of the function"
}
