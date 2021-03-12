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
# Populate common_vars.json to deployment folder
###

resource "local_file" "common_tfvars" {
  filename = "../deployment/common_vars.json"
  content = jsonencode({
    "preemptive" : var.preemptible,
    "project_id" : module.project-management-plane.project_id,
    "region" : var.region,
    "skip_common" : var.skip_common,
    "skip_forward_proxy" : var.skip_forward_proxy,
    "skip_network" : var.skip_network,
    "skip_gke" : var.skip_gke
  })
}