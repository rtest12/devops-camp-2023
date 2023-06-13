module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project]
}

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
  ec2_instances             = [for i in range(var.ec2_instances_count) : "${local.labels.ec2_instance}-${i + 1}"]
}
