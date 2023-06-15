output "nginx" {
  description = "Nginx configuration"
  value       = module.nginx
}

output "redis" {
  description = "Redis configuration"
  value       = var.use_redis ? module.redis[0] : {}
}

output "volume_host_path" {
  description = "Output the volume_host_path value"
  value       = local.volume_host_path
}
