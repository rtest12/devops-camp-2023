/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

environment = "staging"

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

nginx = {
  image          = "nginx:1.21"
  container_name = "saritasa-devops-camps-2023-workspace-staging"
  container_ports = {
    internal = 80,
    external = 9090
  }
  keep_locally = true
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

use_redis = false