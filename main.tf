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
    validation { 
  condition = var.ext_port == 1880
  error_message = "The external port must be 1880"
   
  }
 }


variable "int_port" {
  type = number
  default = 1880
  
  validation { 
  condition = var.int_port == 1880
  error_message = "The internal port must be 1880"
    }
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

output  "ipaddress_and_ports_loop" {
 value = [for i in docker_container.nodered_container[*]: join(":",[i.ip_address], i.ports[*]["external"])]
}      

