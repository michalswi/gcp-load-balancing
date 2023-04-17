# forwarding rule
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name                  = "http-forwarding-rule"
  project               = var.project
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_lb_proxy.self_link
  ip_address            = google_compute_global_address.gke_gateway_external_ip.id
}

# target proxy
resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name    = "http-lb-proxy"
  project = var.project
  url_map = google_compute_url_map.web-map.self_link
}

# URL maps
resource "google_compute_url_map" "web-map" {
  name            = "web-map"
  project         = var.project
  default_service = google_compute_backend_service.http-map-backend-service.self_link
}

# backend services
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
resource "google_compute_backend_service" "http-map-backend-service" {
  name     = "http-map-backend-service"
  project  = var.project
  protocol = "HTTP"
  port_name   = "nodeportsvc"
  timeout_sec = 10
  health_checks = [
    google_compute_health_check.http-basic-check.self_link,
  ]
  # backend {
  #   balancing_mode        = "RATE"
  #   max_rate_per_endpoint = 1
  #   group                 = "projects/${var.project}/zones/${var.region}-a/networkEndpointGroups/<to_be_provided>"
  # }
}

# health checks
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check
resource "google_compute_health_check" "http-basic-check" {
  project = var.project
  name    = "http-basic-check"

  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 1
  unhealthy_threshold = 2

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}
