# Data
data "http" "ipify" {
  url = "https://api.ipify.org"
}

# Enable services
resource "google_project_service" "container" {
  project                    = var.project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
}

# GKE Service Account
resource "google_service_account" "gke" {
  project      = var.project_id
  account_id   = "kubernetes"
  display_name = "GKE Service Account"
}

# GKE Cluster
resource "google_container_cluster" "cluster" {
  provider = google-beta
  depends_on = [
    google_project_service.container
  ]

  project  = var.project_id
  location = var.region

  name                     = "cluster"
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.network.self_link
  subnetwork = google_compute_subnetwork.subnetwork.self_link

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "${chomp(data.http.ipify.body)}/32"
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.3.0.0/28"
  }

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnetwork.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range[1].range_name
  }
}

resource "google_container_node_pool" "node_pool" {
  project  = var.project_id
  location = var.region
  cluster  = google_container_cluster.cluster.name

  name       = "node-pool"
  node_count = 2

  node_config {
    preemptible     = true
    machine_type    = "n2-standard-2"
    service_account = google_service_account.gke.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
