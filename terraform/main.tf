locals {
  project_id       = var.project_id
  network          = "default"
  image            = "debian-cloud/debian-11"
  ssh_user         = "jshangiti"
  private_key_path = "C:/Users/jshangiti.SAFARICOM.000/.ssh/id_rsa"
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_firewall" "ssh-firewall-rule" {
  project       = var.project_id
  name          = "docker-ssh2"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "docker-instance" {
  name         = "docker-instance2"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  tags         = ["docker"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral
    }
  }

  metadata = {
    ssh-keys = "jshangiti:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdhnyM9inYHi0AUI2duCWg/mMBt4NRpnZC1gFxBdWSGnS7Y1z/dFAt5ImX2ESLPysGRjCKTjkg0NGiQ8apYfMF9CFZWclUT5QKso+ucgJOFzHMrHBgC54vRYjeNhLzHqDW7V+nNbk1D4eEn3a8K2A11Hb9nhAZ8qOLL1bQsS2u2fCMH3yiipvMNP/84u0PvZIpfpixXKw0R/DUkbR9szPaXQb1GncPhL9uLqzZRj1c1S9x0fDQjjUQJd0yCdejcXyzPuEN8gfyTLwpt1eJYOpxzJoNA7gcqpvrCuf2PaE/PSShtZNmqxoH5KshZXf2+xCdNB6sRvOgM5kfuiJYGRsT8S96vTqxpgiCulqLQG1EMaZZqiF7tmQfvucgV6PVs/TteR0ak/G4W2SNFlms0fE+R6u5c5Tgy1WVqOFyedlUBQ0RuMsgzNvm6zDMs99H70k+htJCrr3ZvuI9fG2ploDrogWvonv/G7/KSuOvWN/mjJ/wOIf9L2KUko9fKtg0OpM= jshangiti@docker-instance2"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "jshangiti"  // Replace with your SSH username
      private_key = file(local.private_key_path)
      host        = google_compute_instance.docker-instance.network_interface[0].access_config[0].nat_ip
  }
    source      = "C:/Users/OleShangti/yolo/tree/master/playbooks/docker-playbook.yaml"
    destination =  "/tmp/ansible-playbook/docker-playbook.yaml"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "jshangiti"  // Replace with your SSH username
      private_key = file(local.private_key_path)
      host        = google_compute_instance.docker-instance.name
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ansible",  // Install Ansible on the remote instance if not already installed
      "ansible localhost -m file -a 'path=/tmp/ansible state=directory'",  // Create the /tmp/ansible directory if it doesn't exist
      "scp -o StrictHostKeyChecking=no -i ${local.private_key_path} C:/Users/OleShangti/yolo/tree/master/playbooks/docker-playbook.yaml jshangiti@${google_compute_instance.docker-instance.network_interface[0].access_config[0].nat_ip}:/tmp/ansible-playbook/docker-playbook.yaml",
      "ansible-playbook /tmp/ansible/docker-playbook.yaml"  // Execute the playbook on the remote instance
    ]
  }
}

resource "null_resource" "copy-playbook" {
  depends_on = [google_compute_firewall.ssh-firewall-rule]

  provisioner "local-exec" {
    command = "scp -i C:/Users/OleShangti/yolo/tree/master/playbooks/docker-playbook.yaml jshangiti@${google_compute_instance.docker-instance.network_interface[0].access_config[0].nat_ip}:/tmp/ansible/docker-playbook.yaml"
  }
}
