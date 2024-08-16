# Sets up a virtual private cloud and a subnet for the kubernetes
# cluster

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
  depends_on = [
    var.project_id,
    # google_project_service.compute
  ]
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"

  # VMs in this subnetwork without external IP addresses 
  # can access Google APIs and services by using Private Google Access.
  private_ip_google_access = true

}
