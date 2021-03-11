###
# Populate common_vars.json to deployment folder
###

locals {
  bootstrap_tfvars_json = jsondecode(file("bootstrap.auto.tfvars.json"))
  preemptive            = local.bootstrap_tfvars_json.preemptive
  region                = local.bootstrap_tfvars_json.region
  skip_forward_proxy    = local.bootstrap_tfvars_json.skip_forward_proxy
  skip_gke              = local.bootstrap_tfvars_json.skip_gke
}

resource "local_file" "common_tfvars" {
  filename = "../deployment/common_vars.json"
  content = jsonencode({
    "preemptive" : local.preemptive,
    "project_id" : module.project-management-plane.project_id,
    "region" : local.region,
    "skip_forward_proxy" : local.skip_forward_proxy,
    "skip_gke" : local.skip_gke
  })
}