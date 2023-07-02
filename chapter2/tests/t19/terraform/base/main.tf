locals {
  volume_host_path = "${path.cwd}/${var.environment}"
}

module "nginx" {
  source                       = "../_modules/nginx"
  container_image              = var.nginx.image
  container_name               = var.nginx.container_name
  container_ports              = var.nginx.container_ports
  container_volumes            = var.nginx.container_volumes
  volume_host_path             = local.volume_host_path
  container_image_keep_locally = var.nginx.keep_locally
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
}

module "redis" {
  source                       = "../_modules/container"
  count                        = var.use_redis ? 1 : 0
  container_image              = var.redis.image
  container_name               = var.redis.container_name
  container_ports              = var.redis.container_ports
  container_volumes            = var.redis.container_volumes
  volume_host_path             = local.volume_host_path
  container_image_keep_locally = var.redis.keep_locally
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
}
