terraform {
  required_providers {
    docker = {
      source  = "terrafom-provider/docker"
    }
  }
}

provider "docker" {}

# Pulls the image
resource "docker_image" "busybox" {
  name = "busybox:latest"
}
