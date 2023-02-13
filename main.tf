terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.13.0"
    }
  }
}

provider "docker" {
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"

}

resource "random_string" "random" {
  count = 2
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  name  = join("-",["nodered", random_string.random[count.index].result])
  count = 2 
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
#    external = 1880
  }
}

output "container_network" {
  value = join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external] )
  description = "IP address and external port of the container(s)"
}

output "container_names" {
  value = docker_container.nodered_container[*].name
  }