/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ rds db vars                                                                             │
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


variable "rds_engine" {
  description = "Engine for the RDS instance"
}

variable "rds_family" {
  description = "Family for the RDS instance"
}

variable "rds_major_engine_version" {
  description = "Major engine version for the RDS instance"
}

variable "rds_engine_version" {
  description = "Engine version for the RDS instance"
}

variable "rds_instance_class" {
  description = "Instance class for the RDS instance"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for the RDS instance"
}

variable "rds_max_allocated_storage" {
  description = "Max allocated storage for the RDS instance"
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ efs vars                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "efs_name" {
  description = "Name of the EFS file system"
  type        = string
  default     = "wordpress-efs"
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ fqdn vars                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "site_url" {
  description = "site url"
  type        = string
  default     = "tf-maxim-omelchenko.saritasa-camps.link"
}

variable "site_subdomain_part" {
  description = "subdomain part name"
  type        = string
  default     = "tf-maxim-omelchenko"
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ec2 vars                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "ec2_instances_count" {
  type        = number
  description = "Number of WordPress EC2 instances"
  default     = 2
}

variable "ec2_ami_id" {
  type    = string
  default = "ami-01107263728f3bef4"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_volume_size" {
  type    = number
  default = 20
}

variable "ec2_volume_type" {
  type    = string
  default = "gp3"
}

variable "allowed_ssh_ip" {
  description = "Allowed IP address for SSH access"
  type        = string
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

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ssh                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "ssh_cluster_name" {
  type = string
}
