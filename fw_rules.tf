resource "google_compute_firewall" "http" {
  name        = "allow-lb-and-healthcheck"
  network     = google_compute_network.vpc_network.name
  project     = var.project
  target_tags = ["allow-hc"]
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "allow-ssh-from-iap" {
  name    = "allow-ssh-from-iap-tunnel"
  network = google_compute_network.vpc_network.name
  project = var.project
  source_ranges = [
    "35.235.240.0/20",
  ]
  allow {
    protocol = "tcp"
  }
}
