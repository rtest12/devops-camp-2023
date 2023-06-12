resource "docker_image" "container_name" {
  name         = var.container_image
  keep_locally = var.container_image_keep_locally
}

resource "docker_container" "container_name" {
  image = docker_image.container_name.image_id
  name  = var.container_name
  ports {
    internal = var.container_ports.internal
    external = var.container_ports.external
  }
  dynamic "volumes" {
    for_each = var.container_volumes
    content {
      host_path      = abspath("${path.cwd}/${volumes.value.host}")
      container_path = volumes.value.container
      read_only      = false
    }
  }
}
