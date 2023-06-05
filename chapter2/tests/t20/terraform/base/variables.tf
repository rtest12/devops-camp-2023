/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ db vars                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

 variable "rds_db_user" {
  description = "db rds user"
  type        = string
  default     = "user_db"
}

 variable "rds_db_name" {
  description = "rds db name"
  type        = string
  default     = "wordpress_db"
}

variable "efs_name" {
  description = "Name of the EFS file system"
  type        = string
  default     = "wordpress-efs"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "vpc_tags" {
  description = "VPC tags to place cache host into"
  type        = map(string)
  default = {
    Name = "default"
  }
}

variable "site_url" {
  description = "site url"
  type        = string
  default     = "tf-maxim-omelchenko.saritasa-camps.link"
}

variable "subdomain_url" {
  description = "subdomain url"
  type        = string
  default     = "tf-maxim-omelchenko"
}


variable "efs_id" {
  description = "EFS id"
  type        = string
  default = "module.efs.id"
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
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment could be one of dev | staging | prod"
  }
}

variable "tags" {
  description = "tags for the resource"
  type        = map(any)
}
