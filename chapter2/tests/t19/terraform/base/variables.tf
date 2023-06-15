/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "nginx" {
  type = object({
    image          = string
    container_name = optional(string)
    container_ports = list(object({
      internal = number
      external = number
    }))
    container_volumes = list(object({
      host_path      = string
      container_path = string
      read_only      = bool
    }))
    keep_locally = bool
  })
  default = {
    container_volumes = []
    container_ports   = []
    image             = "nginx:latest"
    keep_locally      = false
  }
  validation {
    condition     = can(regex("^(saritasa-devops-camps-2023-).*", var.nginx.container_name))
    error_message = "Container name should be prefixed with saritasa-devops-camps-2023-"
  }
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */


variable "use_redis" {
  description = "Do you need to speed up the perf using redis?"
  type        = bool
}

variable "redis" {
  type = object({
    image          = string
    container_name = optional(string)
    keep_locally   = bool
    container_ports = list(object({
      internal = number
      external = number
    }))
    container_volumes = list(object({
      host_path      = string
      container_path = string
      read_only      = bool
    }))
  })
  default = {
    container_volumes = []
    container_ports   = []
    image             = "nginx:latest"
    keep_locally      = false
  }
  validation {
    condition     = can(regex("^(saritasa-devops-camps-2023-).*", var.redis.container_name))
    error_message = "Container name should be prefixed with saritasa-devops-camps-2023-"
  }
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "client" {
  description = "Client username"
  type        = string
}

variable "project" {
  description = "Project we're working on"
  type        = string
}

variable "environment" {
  description = "Infra environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod", "qa"], var.environment)
    error_message = "Environment could be one of dev | staging | prod | qa"
  }
}
