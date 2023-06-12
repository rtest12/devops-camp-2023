module "wordpress_mysql_rds" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "5.9.0"
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
  port                   = var.rds_port

  publicly_accessible     = false
  monitoring_interval     = var.rds_monitoring_interval
  backup_window           = var.rds_backup_window
  backup_retention_period = var.rds_backup_retention_period
  maintenance_window      = var.rds_maintenance_window

  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]
  subnet_ids                          = toset(data.aws_subnets.rds.ids)
  storage_encrypted                   = true
  deletion_protection                 = false
  options                             = []
  create_db_parameter_group           = false
  iam_database_authentication_enabled = true
  enabled_cloudwatch_logs_exports     = ["audit", "error", "general", "slowquery"]
  tags                                = var.tags
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}
