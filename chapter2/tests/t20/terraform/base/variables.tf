/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ rds db vars                                                                                                      │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "rds_db_user" {
  description = "db rds user"
  type        = string
}

variable "rds_db_name" {
  description = "rds db name"
  type        = string
}

variable "rds_engine" {
  description = "engine for the RDS instance"
  type        = string
}

variable "rds_family" {
  description = "family for the RDS instance"
  type        = string
}

variable "rds_major_engine_version" {
  description = "major engine version for the RDS instance"
  type        = string
}

variable "rds_engine_version" {
  description = "engine version for the RDS instance"
  type        = string
}

variable "rds_instance_class" {
  description = "instance class for the RDS instance"
  type        = string
}

variable "rds_allocated_storage" {
  description = "allocated storage for the RDS instance"
  type        = number
}

variable "rds_max_allocated_storage" {
  description = "max allocated storage for the RDS instance"
  type        = number
}

variable "rds_port" {
  description = "rds port"
  type        = string
}

variable "rds_monitoring_interval" {
  description = "rds monitoring_interval"
  type        = number
}

variable "rds_backup_retention_period" {
  description = "rds backup retention period"
  type        = number
}

variable "rds_backup_window" {
  description = "rds backup window"
  type        = string
}

variable "rds_maintenance_window" {
  description = "rds maintenance window"
  type        = string
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ fqdn vars                                                                                                        │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "root_domain" {
  description = "root domain name"
  type        = string
}

variable "acm_validation_method" {
  description = "acm certificate validation method"
  type        = string
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ec2 vars                                                                                                         │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "ec2_instances_count" {
  description = "number of wordpress ec2 instances"
  type        = number
}

variable "ec2_ami_id" {
  description = "ec2 instances ami id"
  type        = string
}

variable "ec2_instance_type" {
  description = "ec2 instances instance type"
  type        = string
}

variable "ec2_volume_size" {
  description = "ec2 instances volume size"
  type        = number
}

variable "ec2_volume_type" {
  description = "ec2 instances volume type"
  type        = string
}

variable "ec2_ssm_role" {
  description = "ec2 ssm role"
  type        = string
}

variable "ec2_user" {
  description = "ec2 username"
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

variable "password_keys" {
  type        = list(string)
  description = "List of keys for which to generate random passwords"
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ ssh                                                                                                              │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "allowed_ssh_ip" {
  description = "allowed IP addresses for EC2 SSH access"
  type        = list(string)
}
