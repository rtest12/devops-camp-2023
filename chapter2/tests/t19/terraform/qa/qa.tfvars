/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "qa"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    |
  | the path of the host volume is located at base/main.tf                                                           |
  | and by default it uses a folder with the name of the environment at the root of the project.                     │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

nginx = {
  image          = "nginx:1.21"
  container_name = "saritasa-devops-camps-2023-workspace-nginx-qa"
  container_ports = [
    {
      internal = "80"
      external = "10000"
    }
  ]
  container_volumes = [
    {
      host_path      = ""
      container_path = "/usr/share/nginx/html"
      read_only      = true
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
  container_ports = [
    {
      internal = "6379"
      external = "6379"
    }
  ]
  container_volumes = []
  keep_locally      = true
}
