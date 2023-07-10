provider "google" {
  project = var.project_id
  region  = var.project_region
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = var.machine_type
  zone         = "${var.project_region}-b"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = var.machine_image
      labels = {
        my_label = "value"
      }
    }
  }

  allow_stopping_for_update = true

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance"
  region           = var.project_region
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-${var.machine_type}"
  }

  deletion_protection = "false"
}

resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}
