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
  name          = "docker-ssh1"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "docker-instance" {
  name         = "docker-instance"
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
    ssh-keys = "jshangiti:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDb/2SHhl0c7Y0LEivo5R1Wm/rTTDR6Ha7JvV17k9H9DmomXGff38/CcUxEJRaQXHEHYD5ECuttIbK6XFpHAG3VB2tEQKSvsy5Z88KZGV4fD3v07XoYxwyZQckGwuHK6haGj3CNSf8am2vc/0HADwJHjlUrBFDxTChgPlyWc6owXTwYInfOLEyZZZ/9Hr1eQ1fvJjtvNhAb7oGWITmMr+Tgw3KTzy9Jk7lU5Fdf25/8ei+42l2WHSCQ2D+2w43wdD3oSE+mAxqD9GyQFdTQy6dTgMYRKtqDY8OBl6XR4aTPk6Jmvso0Tasi3tg4UkEyvGge7siUHRk1e0JneNEhZJyblmGGRmLEBaEQ+GbvLhqlKGYDmpPXsyCY/ijCnGm0r2oH94Gz8R4ZCe2EWNlrNCHO06Wqujogbjd+ANY8s9QV3rtl24PoSyDCzQ/9Qw80YKNAxh87h0bLYE933gbOYpZKl4vfNKm0arvuINI2RHPtP7MNjyACZWGQiR16qCemskE= jshangiti@docker-instance"
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
