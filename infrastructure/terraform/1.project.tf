terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.48.0"
    }
  }
  required_version = ">= 0.12"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_project" "project" {
  name            = "MXM Challenge"
  project_id      = var.project_id
  billing_account = var.billing_acc
}

resource "google_project_iam_member" "project_owner" {
  for_each = toset([
    "roles/owner",
    "roles/resourcemanager.projectIamAdmin"
  ])
  project = google_project.project.project_id
  role    = each.key
  member  = var.owner
}
