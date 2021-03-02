variable "project_id" {
  description = "Project ID to deploy into"
  type        = string
  default     = null
}

variable "region" {
  description = "Region to deploy into"
  type        = string
  default     = null
}

variable "project_id_bootstrap" {
  description = "The bootstrap GCP project you want to enable APIs on"
  type        = string
  default     = null
}

variable "project_id_management_plane" {
  description = "The management plane GCP project you want to enable APIs on"
  type        = string
  default     = null
}

variable "activate_apis_bootstrap" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default = [
    "cloudbuild.googleapis.com",
    "sourcerepo.googleapis.com",
  ]
}

variable "activate_apis_management_plane" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iap.googleapis.com",
  ]
}