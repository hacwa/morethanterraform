variable "env" {
    type = string
    default = "dev"
    description = "env to deploy to"
}

variable "image" {
    type = map
    description = "image for container"
    default = {
        dev = "nodered/node-red:latest"
        prod = "nodered/node-red:latest-minimal"
    }
}


locals {
container_count = length(var.ext_port)
}

variable "ext_port" {
  type = list
    validation { 
  condition = max(var.ext_port...)  <= 65535 && min(var.ext_port...) > 0
  error_message = "The external port be within the port range 0 - 65535"
  }
 }

variable "int_port" {
  type = list
    validation { 
  condition = max(var.int_port...)  <= 65535 && min(var.int_port...) > 0
  error_message = "The internal port must be 1880"
    }
  }