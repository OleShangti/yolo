terraform {
  required_providers {
    docker = {
      source  = "terraform-providers/docker"
    }
  }
}

provider "docker" {}

 resource "docker_image" "busybox" {
  name = "busybox:latest"
}