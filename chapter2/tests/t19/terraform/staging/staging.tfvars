/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "staging"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    |
  | the path of the host volume is located at base/main.tf                                                           |
  | and by default it uses a folder with the name of the environment at the root of the project.                     │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

nginx = {
  image          = "nginx:1.21"
  container_name = "saritasa-devops-camps-2023-workspace-nginx-staging"
  container_ports = [
    {
      internal = "80"
      external = "9090"
    }
  ]
  container_volumes = [
    {
      host_path = ""
      container = "/usr/share/nginx/html"
      read_only = true
    }
  ]
  keep_locally = true
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

use_redis = false
