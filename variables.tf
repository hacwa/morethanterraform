

variable "image" {
    type = map
    description = "image for container"
    default = {
        dev = "nodered/node-red:latest"
        prod = "nodered/node-red:latest-minimal"
    }
}


locals {
container_count = length(lookup(var.ext_port, terraform.workspace))
}

variable "ext_port" {
  type = map 
    validation { 
  condition = max(var.ext_port["dev"]...)  <= 65535 && min(var.ext_port["dev"]...) >= 1980
  error_message = "The external port be within the port range 0 - 65535"
  }
    validation { 
  condition = max(var.ext_port["prod"]...)  < 1980 && min(var.ext_port["prod"]...) >= 1880
  error_message = "The external port be within the port range 0 - 65535"
  }  
 }

variable "int_port" {
  type = map
    validation { 
  condition = max(var.int_port["dev"]...)  <= 65535 && min(var.int_port["dev"]...) >= 1980
  error_message = "The internal port must be 1880"
    }
    validation { 
  condition = max(var.int_port["prod"]...)  < 1980 && min(var.int_port["dev"]...) >= 1880
  error_message = "The internal port must be 1880"
    }    
  }