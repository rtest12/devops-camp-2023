output "mysql_db_password" {
  value = random_password.db_password.result
  sensitive = true
}

output "ec2_instance_ids" {
  value = [module.ec2_instances["one"].id, module.ec2_instances["two"].id]
}

output "alb_url" {
  value = module.alb.lb_dns_name
}

output "efs_id" {
  value = module.efs.id
}

output "database_host" {
  value = module.db.db_instance_endpoint
}

output "full_record_name" {
  value = "${var.site_url}.${data.aws_route53_zone.domain.name}"
}
