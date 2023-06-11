output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.container_resource.id
}

output "container_id_short" {
  description = "Short ID of the Docker container"
  value       = substr(docker_container.container_resource.id, 0, 12)
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.container_resource.id
}
