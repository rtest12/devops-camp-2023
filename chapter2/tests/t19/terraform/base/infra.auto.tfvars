client    = "maxim-omelchenko"
project   = "environments"
use_redis = false

nginx = {
  image             = "nginx:latest"
  keep_locally      = false
  container_volumes = []
}

redis = {
  image = "redis:latest"
  container_ports = {
    internal = "6379"
    external = "6379"
  }
  keep_locally = false
}
