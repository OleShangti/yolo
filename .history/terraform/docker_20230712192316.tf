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
resource "docker_image" "yolo-client" {
  name = "jshangiti/yolo-client:1.0.0"
}
