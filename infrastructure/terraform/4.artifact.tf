resource "google_artifact_registry_repository" "container_repository" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = "container-repository"
  format        = "DOCKER"
  description   = "Repository for docker images"
}