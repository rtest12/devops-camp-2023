module "nginx" {
  source = "../_modules/nginx"

  cont                         = "nginx"
  container_image              = var.nginx.image
  container_name               = var.nginx.container_name != "" ? var.nginx.container_name : null
  container_ports              = var.nginx.container_ports != "" ? var.nginx.container_ports : null
  container_image_keep_locally = var.nginx.keep_locally
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
}

module "redis" {
  source = "../_modules/container"
  count  = var.use_redis ? 1 : 0

  cont                         = "redis"
  container_image              = var.redis.image
  container_name               = var.use_redis ? var.redis.container_name : null
  container_ports              = var.use_redis ? var.redis.container_ports : null
  container_image_keep_locally = var.redis.keep_locally
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
  container_volume_hostpath    = var.container_volume_hostpath
  container_volume_path        = var.container_volume_path

  depends_on = [module.nginx]
}
