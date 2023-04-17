resource "google_compute_network" "vpc_network" {
  name                    = "${var.name}-network"
  project                 = var.project
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  project       = var.project
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# proxy-only network
resource "google_compute_subnetwork" "subnet_proxy" {
  project                  = var.project
  name                     = "proxy-only-${var.region}"
  private_ip_google_access = false
  ip_cidr_range            = "10.20.0.0/16"
  network                  = google_compute_network.vpc_network.id
  purpose                  = "INTERNAL_HTTPS_LOAD_BALANCER"
  region                   = var.region
  role                     = "ACTIVE"
}
