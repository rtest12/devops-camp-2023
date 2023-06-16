output "wordpress_instances_ids" {
  description = "list of ec2 instances"
  value       = module.wordpress_ec2_instance[*].id
}

output "wordpress_fqdn" {
  description = "wordpress full record FQDN"
  value       = local.domain_name
}

output "rds_mysql_password" {
  sensitive   = true
  description = "mysql database password"
  value       = random_password.passwords_list["db_password"].result
}

output "rds_mysql_endpoint" {
  description = "database connection endpoint"
  value       = module.wordpress_mysql_rds.db_instance_endpoint
}

output "alb_url" {
  description = "application load balancer url"
  value       = module.alb.lb_dns_name
}

output "efs_id" {
  description = "elastic file system id"
  value       = module.efs.id
}
