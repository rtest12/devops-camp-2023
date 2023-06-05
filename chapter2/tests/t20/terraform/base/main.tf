module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project]
}

locals {
  labels = {
    alb_sg          = join(module.label.delimiter, [module.label.id, "alb_sg"])
    alb             = join(module.label.delimiter, [module.label.id, "alb"])
    tg              = join(module.label.delimiter, [module.label.id, "tg"])
    ec2_sg          = join(module.label.delimiter, [module.label.id, "ec2_sg"])
    ec2_instance    = join(module.label.delimiter, [module.label.id, "ec2"])
    efs             = join(module.label.delimiter, [module.label.id, "efs"])
    efs_sg          = join(module.label.delimiter, [module.label.id, "efs_sg"])
    rds_sg          = join(module.label.delimiter, [module.label.id, "rds_sg"])
    rds             = join(module.label.delimiter, [module.label.id, "rds"])
  }
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "all" {}

data "aws_route53_zone" "domain" {
  name         = "saritasa-camps.link"
}

resource "random_password" "wordpress_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "auth_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "secure_auth_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "logged_in_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "nonce_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "auth_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "secure_auth_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "logged_in_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "nonce_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
