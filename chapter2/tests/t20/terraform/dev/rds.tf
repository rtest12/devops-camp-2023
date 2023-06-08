module "wordpress_mysql_rds" {
  source                = "terraform-aws-modules/rds/aws"
  identifier            = local.labels.rds
  engine                = var.rds_engine
  family                = var.rds_family
  major_engine_version  = var.rds_major_engine_version
  engine_version        = var.rds_engine_version
  instance_class        = var.rds_instance_class
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage
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

  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]
  subnet_ids                          = toset(data.aws_subnets.rds.ids)
  storage_encrypted                   = true
  tags                                = var.tags
  deletion_protection                 = false
  options                             = []
  create_db_parameter_group           = false
  iam_database_authentication_enabled = true
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]

  depends_on = [module.wordpress_rds_sg]
}
