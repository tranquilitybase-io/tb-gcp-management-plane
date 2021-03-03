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
  sa_name                = format("%s-%s", var.service_account_prefix, local.unique_id)
  project_roles_bindings = [for role in var.project_roles : format("%s=>%s", var.project_id_bootstrap, role)]
}

###
#  Create bootstrap service account
###

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = var.description
  display_name  = var.display_name
  names         = [local.sa_name]
  project_roles = local.project_roles_bindings
  project_id    = module.project-bootstrap.project_id
}