# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address
resource "google_compute_global_address" "gke_gateway_external_ip" {
  name         = "gke-gateway-external-ip"
  address_type = "EXTERNAL"
  description  = "The public ip used to expose k8s services outside gke to internet"
  project      = var.project
}
