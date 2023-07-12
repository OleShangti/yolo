terraform {
  required_providers {
    docker = {
      source  = "terrafom-provider/docker"
    }
  }
}

provider "docker" {
  host = "https://hub.docker.com/"
}

# Pulls the image
resource "docker_image" "ubuntu" {
  name = "jshangiti/yolo-client:latest"
}

# Create a container
resource "docker_container" "foo" {
  image = docker_image.ubuntu.image_id
  name  = "foo"
}