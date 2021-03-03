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

###
#  Enable project apis
###

module "project-services-bootstrap" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 10.1.1"
  activate_apis               = var.activate_apis_bootstrap
  disable_dependent_services  = false
  disable_services_on_destroy = false
  project_id                  = module.project-bootstrap.project_id
}

module "project-services-management-plane" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 10.1.1"
  activate_apis               = var.activate_apis_management_plane
  disable_dependent_services  = false
  disable_services_on_destroy = false
  project_id                  = module.project-management-plane.project_id
}