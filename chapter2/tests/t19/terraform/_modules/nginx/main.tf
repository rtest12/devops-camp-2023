locals {
  rendered_index_html = templatefile("${path.module}/templates/index.html.tftpl", {
    environment = var.environment
    client      = var.client
  })
}

module "nginx" {
  source                       = "../container"
  container_image              = var.container_image
  container_image_keep_locally = var.container_image_keep_locally
  container_name               = var.container_name
  container_ports              = var.container_ports
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
  container_volumes            = var.container_volumes
  volume_host_path             = var.volume_host_path
}

resource "null_resource" "index_page" {
  provisioner "local-exec" {
    command = <<-EOF
      mkdir ${var.volume_host_path} &&  \
      cat > ${var.volume_host_path}/index.html <<EOF2
      ${local.rendered_index_html}
      EOF2
    EOF
  }
}

resource "null_resource" "delete_folder" {
  triggers = {
    folder_name = "${var.volume_host_path}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.triggers.folder_name}"
  }
}
