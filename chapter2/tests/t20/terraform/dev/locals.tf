locals {
  labels = {
    alb_sg       = join(module.label.delimiter, [module.label.id, "alb_sg"])
    alb          = join(module.label.delimiter, [module.label.id, "alb"])
    tg           = join(module.label.delimiter, [module.label.id, "tg"])
    ec2_sg       = join(module.label.delimiter, [module.label.id, "ec2_sg"])
    ec2_instance = join(module.label.delimiter, [module.label.id, "ec2"])
    efs          = join(module.label.delimiter, [module.label.id, "efs"])
    efs_sg       = join(module.label.delimiter, [module.label.id, "efs_sg"])
    rds_sg       = join(module.label.delimiter, [module.label.id, "rds_sg"])
    rds          = join(module.label.delimiter, [module.label.id, "rds"])
  }
  availability_zone_subnets = data.aws_subnets.wordpress.ids
}
