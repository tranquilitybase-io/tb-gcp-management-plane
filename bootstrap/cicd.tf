resource "google_sourcerepo_repository" "tb-management-plane-repo" {
  name    = local.source_repo_name
  project = var.project_id
}