/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "prod"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

nginx = {
  image          = "nginx:1.21"
  container_name = "saritasa-devops-camps-2023-workspace-nginx-prod"
  container_ports = {
    internal = 80,
    external = 10000
  }
  container_volumes = [
    {
      # host - in root project folder
      host      = "prod"
      container = "/usr/share/nginx/html"
    }
  ]
  keep_locally = true
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

use_redis = true

redis = {
  image          = "redis:7.0"
  container_name = "saritasa-devops-camps-2023-workspace-redis-prod"
  container_ports = {
    internal = 6379
    external = 6379
  }
  keep_locally = true
}
