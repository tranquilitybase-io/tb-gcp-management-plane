# Copyright 2021 The Tranquility Base Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

variable "management_plane_folder_name" {
  description = "Display name for created folder"
  type        = string
  default     = "tb-management-plane"
}

variable "management_plane_project_name" {
  description = "Display name for created management-plane project"
  type        = string
  default     = "tb=management-plane"
}

variable "bootstrap_project_name" {
  description = "Display name for created bootstrap project"
  type        = string
  default     = "tf-bootstrap"
}

variable "billing_id" {
  description = "The ID of the billing account to associate this project with"
  type        = string
  default     = null
}

variable "parent" {
  description = "The resource name of the parent Folder or Organization. Must be of the form folders/folder_id or organizations/org_id"
  type        = string
}

