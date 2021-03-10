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
  bootstrap_sa_name = format("%s-%s", var.service_account_prefix, local.unique_id)
}

###
#  Create bootstrap service account
###

resource "google_service_account" "bootstrap_sa" {
  project      = module.project-bootstrap.project_id
  description  = var.description
  account_id   = local.bootstrap_project_name
  display_name = var.display_name

  depends_on = [module.project-services-bootstrap]
}

resource "google_folder_iam_member" "bootstrap_sa_iam" {
  for_each = toset(var.folder_roles)
  member   = "serviceAccount:${google_service_account.bootstrap_sa.email}"
  folder   = google_folder.tb_management_plane.id
  role     = each.value
}

resource "google_service_account_iam_member" "sa_impersonate_permissions" {
  service_account_id = google_service_account.bootstrap_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${module.project-bootstrap.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_sa_iam" {
  for_each = toset(var.cloudbuild_sa_roles)
  member   = "serviceAccount:${module.project-bootstrap.number}@cloudbuild.gserviceaccount.com"
  project  = module.project-bootstrap.project_id
  role     = each.value

  depends_on = [module.project-services-bootstrap]
}