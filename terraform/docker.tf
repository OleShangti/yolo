provider "docker" {}

# Pull image
resource "docker_image" "images" {
  count = length(var.docker_images)
  name  = var.docker_images[count.index]
}

# # Start a container

resource "docker_container" "containers" {
  count = length(docker_image.images)
  name  = "container${count.index}"
  image = docker_image.images[count.index].name

  depends_on = [ docker_image.images ]

}
