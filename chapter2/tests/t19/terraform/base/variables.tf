/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "nginx" {
  type = object({
    image           = string
    container_name  = optional(string)
    container_ports = optional(map(string))
    container_volumes = list(object({
      host      = string
      container = string
    }))
    keep_locally = bool
  })
  validation {
    condition = (
      can(var.nginx.container_ports) &&
      var.nginx.container_ports["internal"] < "1000" &&
      var.nginx.container_ports["external"] >= "8000"
    )
    error_message = "Container internal port should be less 1000 and external above or equal to 8000"
  }
  validation {
    condition     = can(regex("^(saritasa-devops-camps-2023-).*", var.nginx.container_name))
    error_message = "Container name should be prefixed with saritasa-devops-camps-2023-"
  }
}

variable "container_volumes" {
  type = list(object({
    host      = string
    container = string
  }))
  default = []
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */


variable "use_redis" {
  description = "Do you need to speed up the perf using redis?"
  type        = bool
  default     = false
}

variable "redis" {
  type = object({
    image           = string
    container_name  = optional(string)
    container_ports = optional(map(string))
    keep_locally    = bool
  })
  validation {
    condition = (
      can(var.redis.container_ports) &&
      var.redis.container_ports["internal"] == "6379" &&
      var.redis.container_ports["external"] == "6379"
    )
    error_message = "Both ports should be 6379."
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
