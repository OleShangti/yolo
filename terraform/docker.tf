terraform {
  required_providers {
    docker = {
      source  = "terrafom-providers/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "busybox" {
  name = "busybox:latest"
}
