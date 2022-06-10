provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}


resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.instance_type
  labels = merge(var.additional_labels,
    {
      swqa = "devops"
    }
  )

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.pub-1.self_link
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "pub-1" {
  name = "pub-subnet-1"
  ip_cidr_range = "192.168.1.0/24"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "pub-2" {
  name = "pub-subnet-2"
  ip_cidr_range = "192.168.2.0/24"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "prv-1" {
  name = "prv-subnet-1"
  ip_cidr_range = "192.168.3.0/24"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "prv-2" {
  name = "prv-subnet-2"
  ip_cidr_range = "192.168.4.0/24"
  network = google_compute_network.vpc_network.id
}
