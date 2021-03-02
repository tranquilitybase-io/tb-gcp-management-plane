###
# Generate random string id
###

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  source_repo_name = "tb-management-plane"
}