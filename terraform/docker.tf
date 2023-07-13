provider "docker" {
  host    = "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx.name
  name  = "nginx_container"
  }