provider "google" {
  project = "class-test9"
  region  = "us-central1"
  zone    = "us-central1-a"
}

module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "3.3.0"

  project_id = "class-test9"

  activate_apis = [
    "compute.googleapis.com",
    "oslogin.googleapis.com"
  ]

  disable_services_on_destroy = false
  disable_dependent_services  = false
}

resource "google_compute_network" "ansible" {
  name = "classtest9"
}

resource "google_compute_instance" "ansible" {
  name         = "classtest9"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.ansible.name
    access_config {
    }
  }

  allow_stopping_for_update = true
}