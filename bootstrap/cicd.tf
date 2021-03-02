resource "google_sourcerepo_repository" "tb-management-plane-repo" {
  name    = local.source_repo_name
  project = var.project_id
}

resource "google_cloudbuild_trigger" "bootstrap-cb" {

  trigger_template {
    tag_name   = "0.1.0"
    repo_name  = google_sourcerepo_repository.tb-management-plane-repo.name
    project_id = var.project_id
  }

  substitutions = {
    _PROJECT_ID = var.project_id
    _REGION     = var.region
  }

  project  = var.project_id
  filename = "cloudbuild.yaml"
}