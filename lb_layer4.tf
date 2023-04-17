# # forwarding rule
# resource "google_compute_global_forwarding_rule" "http_rule" {
#   name                  = "http-rule"
#   project               = var.project
#   port_range            = "80"
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   target                = google_compute_target_tcp_proxy.default.self_link
#   ip_address            = google_compute_global_address.gke_gateway_external_ip.id
# }

# resource "google_compute_global_forwarding_rule" "https_rule" {
#   name                  = "https-rule"
#   project               = var.project
#   port_range            = "443"
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   target                = google_compute_target_tcp_proxy.default.self_link
#   ip_address            = google_compute_global_address.gke_gateway_external_ip.id
# }

# # target proxy
# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_tcp_proxy
# resource "google_compute_target_tcp_proxy" "default" {
#   name            = "http-lb-proxy"
#   project         = var.project
#   backend_service = google_compute_backend_service.default.id
# }

# # backend services
# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service
# resource "google_compute_backend_service" "default" {
#   name      = "http-map-backend-service"
#   project   = var.project
#   protocol  = "TCP"
#   port_name = "nodeportsvc"
#   load_balancing_scheme = "EXTERNAL"
#   timeout_sec           = 10
#   health_checks = [
#     google_compute_health_check.http-basic-check.self_link,
#   ]
#   # backend {
#   #   balancing_mode               = "CONNECTION"
#   #   max_connections_per_endpoint = 1
#   #   group                        = "projects/${var.project}/zones/${var.region}-a/networkEndpointGroups/<to_be_provided>"
#   # }
# }

# # health checks
# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check
# resource "google_compute_health_check" "http-basic-check" {
#   project = var.project
#   name    = "http-basic-check"

#   check_interval_sec  = 10
#   timeout_sec         = 5
#   healthy_threshold   = 1
#   unhealthy_threshold = 2

#   http_health_check {
#     port_specification = "USE_SERVING_PORT"
#   }
# }
