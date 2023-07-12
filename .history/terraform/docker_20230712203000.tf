terraform {
  required_providers {
    docker = {
      source  = "terraform-providers/docker"
    }
  }
}

provider "docker" {
  version = "~> 2.7"
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "busybox" {
  name = "yolo:latest"
}
