output "mysql_db_password" {
  description = "mysql database password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "ec2_instance_ids" {
  description = "list of ec2 instances"
  value       = [for instance in module.ec2_instances : instance.id]
}

output "alb_url" {
  description = "application load balancer url"
  value       = module.alb.lb_dns_name
}

output "efs_id" {
  description = "elastic file system id"
  value       = module.efs.id
}

output "db_endpoint" {
  description = "database connection endpoint"
  value       = module.wordpress_mysql_rds.db_instance_endpoint
}

output "wordpress_fqdn" {
  description = "wordpress full record FQDN"
  value       = "${var.site_url}.${data.aws_route53_zone.domain.name}"
}
