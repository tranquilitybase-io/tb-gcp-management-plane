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
  cluster_name   = "tb-mgmt-gke"
  common_vars    = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))
  node_pool_name = "node-pool-1"
  preemptible    = tobool(lookup(local.common_vars, "preemptible", false))
  skip           = tobool(lookup(local.common_vars, "skip_gke", false))
}

terraform {
  source = "github.com/terraform-google-modules/terraform-google-kubernetes-engine//modules/beta-private-cluster?ref=v13.0.0"
}

dependency "network" {
  config_path = "../02-network"
  mock_outputs = {
    network_name           = "network_name"
    subnets_ip_cidr_ranges = ["10.0.0.0/8"]
    subnets_names          = ["subnets_names"]
  }
}

inputs = {
  create_service_account     = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  horizontal_pod_autoscaling = false
  initial_node_count         = 0
  ip_range_pods              = "gke-pods-snet"
  ip_range_services          = "gke-services-snet"
  istio                      = true
  master_ipv4_cidr_block     = "172.16.0.0/28"
  name                       = local.cluster_name
  network                    = dependency.network.outputs.network_name
  region                     = local.common_vars.region
  regional                   = true
  remove_default_node_pool   = true
  subnetwork                 = dependency.network.outputs.subnets_names[0]
  project_id                 = local.common_vars.project_id

  master_authorized_networks = [
    {
      cidr_block   = dependency.network.outputs.subnets_ip_cidr_ranges[0],
      display_name = dependency.network.outputs.network_name
    },
  ]

  node_pools = [
    {
      preemptible        = local.preemptible
      name               = local.node_pool_name
      initial_node_count = 1
      min_count          = 1
      max_count          = 3
      machine_type       = "e2-standard-4"
      disk_size_gb       = "50"
      disk_type          = "pd-ssd"
    }
  ]

  node_pools_oauth_scopes = {
    node-pool-1 = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_tags = {
    node-pool-1 = [
      local.cluster_name
    ]
  }
}

skip = local.skip