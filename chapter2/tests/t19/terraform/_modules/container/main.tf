resource "docker_image" "image_name" {
  name         = var.container_image
  keep_locally = var.container_image_keep_locally
}

resource "docker_container" "container_name" {
  image = docker_image.image_name.image_id
  name  = var.container_name
  dynamic "ports" {
    for_each = var.container_ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }
  dynamic "volumes" {
    for_each = var.container_volumes
    content {
      host_path      = var.volume_host_path
      container_path = volumes.value.container_path
      read_only      = volumes.value.read_only
    }
  }
}
