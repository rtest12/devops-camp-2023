module "container" {
  container_resource           = "nginx"
  source                       = "../container"
  container_image              = var.container_image
  container_image_keep_locally = var.container_image_keep_locally
  container_name               = var.container_name != null ? var.container_name : ""
  container_ports              = var.container_ports
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
  container_volumes            = var.container_volumes
}

resource "null_resource" "index_page" {
  provisioner "local-exec" {
    command = "mkdir ${path.cwd}/${var.environment} && cat > ${path.cwd}/${var.environment}/index.html  <<EOL\n${local.rendered_index_html}\nEOL"
  }
}

resource "null_resource" "delete_folder" {
  triggers = {
    folder_name = "${path.cwd}/${var.environment}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.triggers.folder_name}"
  }
}
