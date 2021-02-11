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
  //cluster_name = format("%s-%s", "gke-ec", local.prefix)
}

terraform {
  source = "github.com/terraform-google-modules/terraform-google-kubernetes-engine//modules/beta-private-cluster?ref=v12.3.0"
}

dependency "network" {
  config_path = "../02-network"
  mock_outputs = {
    subnets_names = ["subnets_names"]
    network_name  = "network_name"
  }
}

inputs = {
  region                    = local.common_vars.region
  network                   = dependency.network.outputs.network_name
  subnetwork                = dependency.network.outputs.subnets_names[0]
  project_id                = local.common_vars.project_id
  name                      = "tb-mgmt-gke"
  ip_range_pods             = "gke-pods-snet"
  ip_range_services         = "gke-services-snet"
  enable_private_endpoint   = true
  enable_private_nodes      = true
  remove_default_node_pool  = true
  initial_node_count        = 0
  maintenance_start_time    = "02:00"
  monitoring_service        = "monitoring.googleapis.com/kubernetes"
  logging_service           = "logging.googleapis.com/kubernetes"
  basic_auth_username       = ""
  basic_auth_password       = ""
  issue_client_certificate  = false
  default_max_pods_per_node = 110
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
  master_ipv4_cidr_block     = "172.16.0.0/28"
  horizontal_pod_autoscaling = false
  kubernetes_version         = "latest"
  istio                      = true
  istio_auth                 = "AUTH_MUTUAL_TLS"

  node_pools = [
    {
      name                   = "gke-ec-node-pool"
      initial_node_count     = 1
      min_count              = 1
      max_count              = 3
      machine_type           = "e2-standard-4"
      disk_size_gb           = "30"
      create_service_account = true
    }
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "gke-private",
      local.cluster_name
    ]
  }
}

skip = local.skip

