variable "docker_images" {
  type = list(string)
  default = [
    "redis:3.2.11-alpine",
    "mysql:5.7.21",
  ]
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "machine_image" {
  type    = string
  default = "debian-cloud/debian-11"
}

variable "project_id" {
  type = string
}

variable "project_region" {
  type = string
  default = "us-west1"