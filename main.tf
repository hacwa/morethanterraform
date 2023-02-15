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

variable "ext_port" {
  type = number
  default = 1880
  }

variable "int_port" {
  type = number
  default = 1880
  }

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"

}

variable "container_count" {
  type = number
  default =  1
}


resource "random_string" "random" {
  count = var.container_count
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  name  = join("-",["nodered", random_string.random[count.index].result])
  count = var.container_count
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}


# output "ip-address" {
#   value = join(":", flatten([docker_container.nodered_container[*].ip_address, docker_container.nodered_container[*].ports[0].external]))
#   description = "the IP address and external port of the container"
# }

# output "container_network" {
#   value = join(":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external] )
#   description = "IP address and external port of the container(s)"
# }

# output "container_names" {
#   value = docker_container.nodered_container[*].name
#   }
  
output  "ipaddress_and_ports_loop" {
 value = [for i in docker_container.nodered_container[*]: join(":",[i.ip_address], i.ports[*]["external"])]
}