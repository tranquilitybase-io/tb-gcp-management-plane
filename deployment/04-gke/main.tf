locals {
  prefix       = var.random_id
  cluster_name = format("%s-%s", "gke-ec", local.prefix)
  sa_name      = "kubernetes-ec"
  sa_email     = format("%s@%s.%s", local.sa_name, var.project_id, "iam.gserviceaccount.com")
}