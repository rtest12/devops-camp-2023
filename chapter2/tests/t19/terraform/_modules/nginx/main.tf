module "container" {
  cont                      = "nginx"
  source                    = "../container"
  container_image           = var.container_image
  container_image_keep_locally = var.container_image_keep_locally
  container_name            = var.container_name != null ? var.container_name : ""
  container_ports           = var.container_ports
  client                    = var.client
  project                   = var.project
  environment               = var.environment
  container_volume_hostpath = "${abspath(path.root)}/../../${var.environment}"
  container_volume_path     = "/usr/share/nginx/html"
}

resource "null_resource" "index_page" {
  provisioner "local-exec" {
    command = "mkdir ../../${var.environment} && cat > ../../${var.environment}/index.html  <<EOL\n${local.rendered_index_html}\nEOL"
  }
}
