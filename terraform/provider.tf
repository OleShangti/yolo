terraform {
  required_providers {
    docker = {
      source  = "terraform-providers/docker"
      version = "~> 2.7.2"
    }

    google = {
      source  = "hashicorp/google"
      version = "4.73.0"
    }
  }

  required_version = ">= 0.15.0"
}