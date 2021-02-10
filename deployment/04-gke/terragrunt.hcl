//# Copyright 2021 The Tranquility Base Authors
//#
//# Licensed under the Apache License, Version 2.0 (the "License");
//# you may not use this file except in compliance with the License.
//# You may obtain a copy of the License at
//#
//#     http://www.apache.org/licenses/LICENSE-2.0
//#
//# Unless required by applicable law or agreed to in writing, software
//# distributed under the License is distributed on an "AS IS" BASIS,
//# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//# See the License for the specific language governing permissions and
//# limitations under the License.
//
//# Include all settings from the root terragrunt.hcl file
//include {
//  path = find_in_parent_folders()
//}
//
//locals {
//  common_vars = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))
//  skip        = lookup(local.common_vars, "skip_gke", false)
//}
//
//terraform {
//  source = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
//  version = "12.3.0"
//}
//
//inputs {
//    region                     = var.region
//    network                    = var.network_name
//    subnetwork                 = var.subnet_name
//    project_id                 = var.project_id
//    name                       = local.cluster_name
//    ip_range_pods              = var.pod_network_name
//    ip_range_services          = var.service_network_name
//    enable_private_endpoint    = true
//    enable_private_nodes       = true
//    remove_default_node_pool   = var.remove_default_node_pool
//    initial_node_count         = 0
//    maintenance_start_time     = var.maintenance_start_time
//    monitoring_service         = var.pod_mon_service
//    logging_service            = var.pod_log_service
//    basic_auth_username        = ""
//    basic_auth_password        = ""
//    issue_client_certificate   = var.issue_client_certificate
//    default_max_pods_per_node  = var.default_max_pods_per_node
//    master_authorized_networks = var.master_authorized_networks
//    master_ipv4_cidr_block     = var.cluster_master_cidr
//    horizontal_pod_autoscaling = var.horizontal_pod_autoscaling
//    kubernetes_version         = var.kubernetes_version
//    istio                      = var.istio_status
//    istio_auth                 = var.istio_permissive_mtls == "true" ? "AUTH_NONE" : "AUTH_MUTUAL_TLS"
//
//    node_pools = [
//      {
//        name               = var.node_pool_name
//        initial_node_count = var.initial_node_count
//        min_count          = var.autoscaling_min_nodes
//        max_count          = var.autoscaling_max_nodes
//        machine_type       = var.node_machine_type
//        disk_size_gb       = var.node_disk_size_gb
//        service_account    = local.sa_email
//      }
//    ]
//
//    node_pools_oauth_scopes = {
//      all = []
//
//      default-node-pool = [
//        var.node_oauth_scopes,
//      ]
//    }
//
//    node_pools_tags = {
//      all = []
//
//      default-node-pool = [
//        "gke-private",
//        local.cluster_name
//      ]
//    }
//  }
//
//skip = local.skip
//
