variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "subnet_cidr" {
  description = "CIDR range for non-GKE VMs"
}

variable "node_cidr" {
  description = "CIDR range for GKE Nodes"
}

variable "pod_cidr" {
  description = "CIDR range for GKE Pods"
}

variable "services_cidr" {
  description = "CIDR range for GKE Services"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  description             = "VPC for ${var.project_id}"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.self_link
  ip_cidr_range = var.subnet_cidr

  secondary_ip_range {
    range_name    = "nodes"
    ip_cidr_range = var.node_cidr
  }

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pod_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }

  # Enable Private Google Access
  private_ip_google_access = true

  # Enable Flow Logs
  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  description = "Subnet for ${var.project_id}"
}
