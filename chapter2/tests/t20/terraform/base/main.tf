module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project]
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "all" {}

data "aws_route53_zone" "domain" {
  name = "saritasa-camps.link"
}
