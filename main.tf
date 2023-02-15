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

resource "null_resource" "dockervol" {
  provisioner  "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}


resource "docker_image" "nodered_image" {
  name = lookup(var.image, var.env)
}

resource "random_string" "random" {
  count = local.container_count
  length = 4
  special = false
  upper = false
}

resource "docker_container" "nodered_container" {
  name  = join("-",["nodered", random_string.random[count.index].result])
  count = local.container_count
  image = docker_image.nodered_image.latest
  ports {
    internal = lookup(var.int_port, var.env)[count.index]
    external = lookup(var.ext_port, var.env)[count.index]
  }
  volumes { 
  container_path = "/data"
  host_path = "${path.cwd}/noderedvol"
  }
}