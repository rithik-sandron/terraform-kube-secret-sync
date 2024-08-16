# GKE cluster
resource "google_container_cluster" "primary" {
  name           = "${var.project_id}-gke"
  location       = var.region
  node_locations = [var.zone]
  remove_default_node_pool = true
  initial_node_count       = 1
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  enable_shielded_nodes = true
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  depends_on = [
    # google_project_service.container
  ]
}

# Separately Managed Node Pool for mlflow tracking server and other cpu pods
resource "google_container_node_pool" "cpu-pool" {
  name     = "${var.project_id}-cpu-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name
  node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = var.max_cpu_nodes
  }

  node_config {
    service_account = google_service_account.model-trainer.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      env = var.project_id
    }
    preemptible  = false
    machine_type = var.cpu_machine_type
    tags = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

