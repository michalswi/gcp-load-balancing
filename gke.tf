locals {
  cluster_master_ip_cidr_range   = "10.30.10.0/28"
  cluster_pods_ip_cidr_range     = "10.31.0.0/21"
  cluster_services_ip_cidr_range = "10.32.0.0/21"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary" {
  name                     = "${var.name}-gke-cluster"
  project                  = var.project
  location                 = var.region
  remove_default_node_pool = false
  initial_node_count       = 1
  node_locations           = ["${var.region}-a"]
  network                  = google_compute_network.vpc_network.name
  subnetwork               = google_compute_subnetwork.subnet.name
  node_config {
    preemptible  = true
    machine_type = "e2-medium"
  }

  # VPC-native routing
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = local.cluster_pods_ip_cidr_range
    services_ipv4_cidr_block = local.cluster_services_ip_cidr_range
  }
}

# named port
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_named_port
resource "google_compute_instance_group_named_port" "port" {
  project = var.project
  name    = "nodeportsvc"
  port    = 80
  group   = google_container_cluster.primary.node_pool[0].instance_group_urls[0]
  zone    = "${var.region}-a"
}
