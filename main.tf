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
  length = 4
  special = false
  upper = false
}

resource "random_string" "random2" {
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container1" {
  name  = join("-",["nodered", random_string.random.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
#    external = 1880
  }
}

resource "docker_container" "nodered_container2" {
  name  = join("-",["nodered", random_string.random2.result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
#    external = 1880
  }
}


output "container1" {
  value = join(":", [docker_container.nodered_container1.ip_address, docker_container.nodered_container1.ports[0].external, docker_container.nodered_container1.name] )
  description = "the name, IP address and external port of the container"
}
output "container2" {
  value = join(":", [docker_container.nodered_container2.ip_address, docker_container.nodered_container2.ports[0].external, docker_container.nodered_container2.name] )
  description = "the name, IP address and external port of the container"
}
output "container_names"{
  value = join("____and_den____", [docker_container.nodered_container1.name ,docker_container.nodered_container2.name ])
}