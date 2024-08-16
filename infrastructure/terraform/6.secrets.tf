resource "google_service_account" "model-trainer" {
  account_id   = "sa-custom"
  display_name = "custom service accoint to access secrets"
}

resource "google_project_iam_member" "secret_admin" {
  for_each = toset([
    "roles/secretmanager.admin",
    "roles/artifactregistry.reader"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.model-trainer.email}"
  depends_on = [
    # google_project_service.compute
  ]
}

resource "google_service_account_iam_binding" "binding" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.model-trainer.name
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/default]",
  ]
}

resource "google_secret_manager_secret" "test_secret" {
  secret_id = "test-secret1"
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "test_secret" {
  secret      = google_secret_manager_secret.test_secret.id
  secret_data = "test-value1"
}

