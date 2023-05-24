output "container_id" {
  description = "ID of the Docker container"
  value       = module.container.container_id
}

output "container_id_short" {
  description = "Short ID of the Docker container"
  value       = module.container.container_id_short
}

output "image_id" {
  description = "ID of the Docker image"
  value       = module.container.image_id
}
