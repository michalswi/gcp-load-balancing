
output "gke-gateway-external-ip" {
  value = google_compute_global_address.gke_gateway_external_ip.address
}

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project" {
  value       = var.project
  description = "GCloud project"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}
