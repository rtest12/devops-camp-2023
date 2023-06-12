/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "qa"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    |
  | the host folder in the root directory of the project, the full path is constructed in _modules/container/main.tf │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

nginx = {
  image          = "nginx:1.21"
  container_name = "saritasa-devops-camps-2023-workspace-nginx-qa"
  container_ports = {
    internal = 80,
    external = 10000
  }
  container_volumes = [
    {
      host      = "qa"
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
  container_name = "saritasa-devops-camps-2023-workspace-redis-qa"
  container_ports = {
    internal = 6379
    external = 6379
  }
  keep_locally = true
}
