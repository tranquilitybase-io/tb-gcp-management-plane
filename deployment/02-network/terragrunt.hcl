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
  common_vars  = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))
  network_name = "tb-mgmt-network"
  project_id   = local.common_vars.project_id
  region       = local.common_vars.region
  skip         = tobool(lookup(local.common_vars, "skip_networks", false))
  subnet_name  = "tb-mgmt-snet-${local.common_vars.region}"
}

terraform {
  source = "github.com/tranquilitybase-io/tf-gcp-network-service.git?ref=v0.1.2"
}

inputs = {
  firewall_custom_rules = {
    "allow-iap-ssh" : {
      "action" : "allow",
      "description" : "Allow inbound SSH connections from IAP",
      "direction" : "INGRESS",
      "extra_attributes" : {},
      "ranges" : [
        "35.235.240.0/20"
      ],
      "rules" : [
        {
          ports : ["22"],
          protocol : "tcp"
        }
      ],
      "sources" : null,
      "targets" : ["allow-iap-ssh"],
      "use_service_accounts" : false
    },
    "allow-proxy-healthcheck" : {
      "action" : "allow",
      "description" : "Allow incoming healthcheck traffic",
      "direction" : "INGRESS",
      "extra_attributes" : {},
      "ranges" : [
        "130.211.0.0/22",
        "35.191.0.0/16"
      ],
      "rules" : [
        {
          ports : ["3128"],
          protocol : "tcp"
        }
      ],
      "sources" : null,
      "targets" : ["allow-proxy-healthcheck"],
      "use_service_accounts" : false
    }
  }

  network_name = local.network_name
  project_id   = local.project_id
  region       = local.region
  subnets = [
    {
      subnet_name               = local.subnet_name
      subnet_ip                 = "10.64.0.0/20"
      subnet_region             = local.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]
  secondary_ranges = {
    "${local.subnet_name}" = [
      {
        range_name    = "gke-services-snet"
        ip_cidr_range = "192.168.64.0/23"
      },
      {
        range_name    = "gke-pods-snet"
        ip_cidr_range = "192.168.128.0/19"
      }
    ]
  }
}

skip = local.skip