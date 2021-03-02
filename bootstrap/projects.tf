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

locals {
  unique_id                     = random_string.suffix.result
  management_plane_folder_name  = format("%s-%s", var.management_plane_folder_name, local.unique_id)
  management_plane_project_name = format("%s-%s", var.management_plane_folder_name, local.unique_id)
  bootstrap_project_name        = format("%s-%s", var.bootstrap_project_name, local.unique_id)
}

module "folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0.0"
  names   = [local.management_plane_folder_name, ]
  parent  = var.parent
}

module "project-bootstrap" {
  source          = "terraform-google-modules/project-factory/google//modules/fabric-project"
  version         = "~> 10.1.1"
  billing_account = var.billing_id
  name            = local.bootstrap_project_name
  parent          = module.folders.id
}

module "project-management-plane" {
  source          = "terraform-google-modules/project-factory/google//modules/fabric-project"
  version         = "~> 10.1.1"
  billing_account = var.billing_id
  name            = local.management_plane_project_name
  parent          = module.folders.id
}