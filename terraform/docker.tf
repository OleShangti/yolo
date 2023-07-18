provider "docker" {
  version = "~> 2.6"
  host    = "npipe:////.//pipe//docker_engine"
}

# Create the image in the environment
resource "docker_image" "image" {
  name = "ubuntu:latest"
}

# Create a custom network
resource "docker_network" "private_network" {
  name = "yolo-test-network"
  ipam_config {
    subnet = "172.61.0.0/16"
  }
}

# Create a volume
resource "docker_volume" "private_volume" {
  name = "yolo_yolo-test-network"
}

/* # Start a container
resource "docker_container" "backend_container" {
  name  = "backend_container"
  image = docker_image.image.name
  networks_advanced {
    name = docker_network.private_network.name
  }
  volumes {
    volume_name = docker_volume.private_volume.id
  }
}  */