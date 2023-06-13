variable "container_image" {
  description = "Value of the name for the Docker container"
  type        = string
}

variable "container_image_keep_locally" {
  description = "If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
  type        = bool
}

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  validation {
    condition     = var.container_name != null && var.container_name != ""
    error_message = "The container_name must not be empty or null."
  }
}

variable "container_ports" {
  description = "Value of the name for the Docker container"
  type        = map(any)
}

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

variable "container_volumes" {
  description = "A list of volumes to be mounted to the container"
  type        = list(object({ host = string, container = string }))
}
