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

dependency "common" {
  config_path = "../01-common"
  mock_outputs = {
    vpc_name    = "vpc_name"
    subnet_name = "subnet_name"
    vpc_id      = "vpc_id"
  }
}

dependency "gke" { //need to make output
  config_path = "../01-gke"
  mock_outputs = {
    cluster_name = "cluster_name"
  }
}

inputs = {
  vpc_id            = dependency.common.outputs.vpc_id
  vpc_name          = dependency.common.outputs.vpc_name
  subnet_name       = dependency.common.outputs.subnet_name
  cluster_name      = dependency.gke.outputs.cluster_name
  folder_id         = get_env("folder_id")
  billing_id        = get_env("billing_id")
  state_bucket_name = get_env("state_bucket_name")
}
