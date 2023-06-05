module "db" {
  source  = "terraform-aws-modules/rds/aws"
  identifier            = local.labels.rds
  engine                = "mysql"
  family                = "mysql8.0"
  major_engine_version  = "8.0"
  engine_version        = "8.0"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  max_allocated_storage = 1000
  skip_final_snapshot   = true

  db_name                = var.rds_db_name
  username               = var.rds_db_user
  create_random_password = false
  password               = random_password.db_password.result
  port                   = "3306"

  publicly_accessible     = false
  monitoring_interval     = 0
  backup_window           = "03:00-06:00"
  backup_retention_period = 10
  maintenance_window      = "Mon:20:00-Mon:20:30"

  vpc_security_group_ids  = [module.rds_sg.security_group_id]
  subnet_ids              = toset(data.aws_subnets.ec2.ids)
  storage_encrypted       = true
  tags                    = var.tags
  deletion_protection     = false
  options                   = []
  create_db_parameter_group = false
  iam_database_authentication_enabled = true
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]

  depends_on = [module.rds_sg]
}

module "rds_sg" {
  source                  = "terraform-aws-modules/security-group/aws"
  version                 = "4.17.2"
  name                    = local.labels.rds_sg
  description             = "rds security group"
  vpc_id                  = data.aws_vpc.target.id
  ingress_cidr_blocks     = [data.aws_vpc.target.cidr_block]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]
  egress_rules            = ["all-all"]
  tags                    = var.tags
}
