/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

client    = "maxim-omelchenko"
project   = "environments"
use_redis = false

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    |
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

nginx = {
  image        = "nginx:latest"
  keep_locally = false
  container_ports = [
    {
      internal = "80"
      external = "8000"
    }
  ]
  container_volumes = [
    {
      container_path = "/usr/share/nginx/html"
      read_only      = true
    }
  ]
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

redis = {
  image = "redis:latest"
  container_ports = [
    {
      internal = "6379"
      external = "6379"
    }
  ]
  container_volumes = []
  keep_locally      = false
}
