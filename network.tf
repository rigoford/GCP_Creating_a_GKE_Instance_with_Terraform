# VPC Network
resource "google_compute_network" "network" {
  project                 = var.project_id
  name                    = "network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  project = var.project_id
  region  = var.region
  network = google_compute_network.network.id

  name          = "subnetwork"
  ip_cidr_range = "10.0.0.0/16"

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.2.0.0/16"
  }
}
