module "wordpress_ec2_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.1.0"
  name                = local.labels.ec2_sg
  description         = "Security group for the ec2 instances"
  vpc_id              = data.aws_vpc.target.id
  ingress_cidr_blocks = [data.aws_vpc.target.cidr_block]
  ingress_rules       = ["all-all"]
  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = "http-80-tcp"
  #     to_port     = "http-80-tcp"
  #     protocol    = "tcp"
  #     description = "http"
  #     cidr_blocks = "0.0.0.0/0"
  #   }
  # ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.wordpress_rds_sg.security_group_id
      description              = "mysql from rds"
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
    },
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
  ingress_with_source_security_group_id = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = module.wordpress_ec2_sg.security_group_id
    },
  ]
  # ingress_rules        = ["https-443-tcp"]
  egress_rules = ["all-all"]
  tags         = var.tags
}
