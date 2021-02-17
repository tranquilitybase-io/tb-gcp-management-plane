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
  skip        = lookup(local.common_vars, "skip_gke", false)

  //prefix       = local.common_vars.random_id
  cluster_name = "tb-mgmt-gke"
}

terraform {
  source = "github.com/terraform-google-modules/terraform-google-kubernetes-engine//modules/beta-private-cluster?ref=v13.0.0"
}

dependency "network" {
  config_path = "../02-network"
  mock_outputs = {
    network_name           = "network_name"
    subnets_ip_cidr_ranges = "subnets_ip_cidr_ranges"
    subnets_names          = ["subnets_names"]
  }
}

inputs = {
  project_id                 = local.common_vars.project_id
  name                       = local.cluster_name
  region                     = local.common_vars.region
  regional                   = false
  network                    = dependency.network.outputs.network_name
  subnetwork                 = dependency.network.outputs.subnets_names[0]
  zones                      = ["europe-west2-c"]
  ip_range_pods              = "gke-pods-snet"
  ip_range_services          = "gke-services-snet"
  create_service_account     = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  remove_default_node_pool   = true
  initial_node_count         = 1
  horizontal_pod_autoscaling = false
  istio                      = true
  maintenance_start_time     = "02:00"
  monitoring_service         = "monitoring.googleapis.com/kubernetes"
  logging_service            = "logging.googleapis.com/kubernetes"
  default_max_pods_per_node  = 110
  master_ipv4_cidr_block     = "172.16.0.0/28"

  master_authorized_networks = [
    {
      cidr_block   = "10.0.0.0/8",
      display_name = "mgmt-1"
    },
    {
      cidr_block   = "10.0.6.0/24",
      display_name = "proxy-subnet"
    },
    {
      cidr_block   = "172.16.0.18/32",
      display_name = "initial-admin-ip"
    }
  ]

  node_pools = [
    {
      preemptible        = true
      name               = "gke-node-pool-ec"
      initial_node_count = 1
      min_count          = 1
      max_count          = 3
      machine_type       = "e2-standard-4"
      disk_size_gb       = "50"
      disk_type          = "pd-ssd"
    }
  ]

  node_pools_oauth_scopes = {
    gke-node-pool-ec = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_tags = {
    gke-node-pool-ec = [
      "gke-private",
      local.cluster_name
    ]
  }
}

skip = local.skip