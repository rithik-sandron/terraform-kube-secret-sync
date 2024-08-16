output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "project" {
 value =  google_project.project.id
}

output "billing_id" {
 value =  google_project.project.billing_account
}

output "region" {
  value = var.region
}

output "zone" {
  value = var.zone
}