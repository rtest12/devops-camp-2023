resource "docker_image" "cont" {
  name         = var.container_image
  keep_locally = var.container_image_keep_locally
}

resource "docker_container" "cont" {
  image = docker_image.cont.image_id
  name  = var.container_name
  ports {
    internal = var.container_ports.internal
    external = var.container_ports.external
  }
  dynamic "volumes" {
    for_each = var.container_volume_hostpath != "" && var.container_volume_path != "" ? [1] : []
    content {
      host_path      = var.container_volume_hostpath
      container_path = var.container_volume_path
    }
  }
  provisioner "local-exec" {
    command     = "./delete_folder.sh"
    working_dir = path.module
    when        = destroy
  }
}
