terraform {
  required_providers {
    docker = {
      source  = "terrafom-provider/docker"
    }
  }
}

provider "docker" {}

resource "docker_image" "busybox" {
  name = "busybox:latest"
}
