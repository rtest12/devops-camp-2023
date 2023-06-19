/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "dev"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    |
  | the host folder in the root directory of the project, the full path is constructed in _modules/container/main.tf │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

nginx = {
  image          = "nginx:1.21"
  container_name = "saritasa-devops-camps-2023-workspace-nginx-dev"
  container_ports = [
    {
      internal = "80"
      external = "10000"
    }
  ]
  container_volumes = [
    {
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
