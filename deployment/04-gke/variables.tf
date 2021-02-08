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

variable "remove_default_node_pool" {
  type = bool
  default = true
}

variable "initial_node_count" {
  type = number
  default = 1
}

variable "maintenance_start_time" {
  type    = string
  default = "02:00"
}

variable "pod_mon_service" {
  type    = string
  default = "monitoring.googleapis.com/kubernetes"
}

variable "pod_log_service" {
  type    = string
  default = "logging.googleapis.com/kubernetes"
}

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  default = 110
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
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
}

variable "pod_network_name" {
  type        = string
  default     = "gke-pods-snet"
  description = "Name for the gke pod network"
}

variable "service_network_name" {
  type        = string
  default     = "gke-services-snet"
  description = "Name for the gke service network"
}

variable "cluster_master_cidr" {
  type = string
  default = "172.16.0.0/28"
}

variable "node_pool_name" {
  description = "The cluster pool name"
  default = "gke-ec-node-pool"

}

variable "autoscaling_min_nodes" {
  type = string
  default = 1
}

variable "autoscaling_max_nodes" {
  type = string
  default = 3
}

variable "node_machine_type" {
  type    = string
  default = "e2-standard-4"
}

variable "node_disk_size_gb" {
  type    = string
  default = "30"
}

variable "node_oauth_scopes" {
  type = string
  default = "https://www.googleapis.com/auth/cloud-platform"
}

variable "kubernetes_version" {
  default     = "latest"
  description = "Master node minimal version"
  type        = string
}

variable "istio_status" {
  type    = bool
  default = "true"
}

variable "istio_permissive_mtls" {
  type    = string
  default = "false"
}

variable "issue_client_certificate" {
  default = false
}

variable "horizontal_pod_autoscaling" {
  default = false
}

// // terragrunt variables // //

variable "network_name" {
}

variable "subnet_name" {
}

// // exported variables // //

variable "random_id" {
}

variable "project_id" {
}

variable "region" {
}


