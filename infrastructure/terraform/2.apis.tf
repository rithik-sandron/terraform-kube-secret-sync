# apis
resource "google_project_service" "project_apis" {
  for_each = toset([
    "cloudbilling.googleapis.com",
    "secretmanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "appengine.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    # "dataflow.googleapis.com"
  ])
  project = google_project.project.project_id
  service = each.key
  disable_on_destroy = false
}