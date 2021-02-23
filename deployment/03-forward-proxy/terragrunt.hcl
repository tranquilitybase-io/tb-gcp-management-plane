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

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))
  preemptible = tobool(lookup(local.common_vars, "preemptible", false))
  skip        = tobool(lookup(local.common_vars, "skip_forward_proxy", false))
}

terraform {
  source = "github.com/tranquilitybase-io/tf-gcp-forward-proxy-service?ref=v0.1.1"
}

dependency "network" {
  config_path = "../02-network"
  mock_outputs = {
    subnet_name = ["subnet_name"]
  }
}

inputs = {
  preemptible = local.preemptible
  project_id  = local.common_vars.project_id
  region      = local.common_vars.region
  subnet_name = dependency.network.outputs.subnets_names[0]
}

skip = local.skip