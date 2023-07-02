data "aws_vpc" "target" {
  tags = var.vpc_tags
}

data "aws_subnets" "wordpress" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_subnets" "rds" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}

data "aws_availability_zones" "all" {}

data "aws_route53_zone" "domain" {
  name = var.root_domain
}
