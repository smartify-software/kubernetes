# GKE Cluster Configuration
variable "cluster_name" {
  description = "The name of the GKE cluster"
}

variable "node_count" {
  description = "The number of worker nodes in the cluster"
}

variable "machine_type" {
  description = "The machine type for the worker nodes"
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network    = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.subnet.self_link

  # Enable network policy to enforce pod-level network rules
  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  node_pool {
    autoscaling {
      min_node_count = 1
      max_node_count = 3
    }

    # Enable auto-upgrade and auto-repair for nodes
    management {
      auto_upgrade = true
      auto_repair  = true
    }

  }
}
