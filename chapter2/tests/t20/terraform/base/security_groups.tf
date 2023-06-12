module "wordpress_ec2_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.1.0"
  name                = local.labels.ec2_sg
  description         = "Security group for the ec2 instances"
  vpc_id              = data.aws_vpc.target.id
  ingress_cidr_blocks = [data.aws_vpc.target.cidr_block]
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.allowed_ssh_ip
      description = "ssh access from allowed vpn ip"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    }
  ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.wordpress_alb_sg.security_group_id
      description              = "allow http from alb"
    }
  ]
  egress_rules = ["all-all"]
  tags         = var.tags
}

module "wordpress_rds_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.1.0"
  name                = local.labels.rds_sg
  description         = "rds security group"
  vpc_id              = data.aws_vpc.target.id
  ingress_cidr_blocks = [data.aws_vpc.target.cidr_block]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.wordpress_ec2_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]
  tags         = var.tags
}

module "wordpress_alb_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.1.0"
  name                = local.labels.alb_sg
  description         = "security group for alb"
  vpc_id              = data.aws_vpc.target.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  egress_rules        = ["all-all"]
  tags                = var.tags
}
