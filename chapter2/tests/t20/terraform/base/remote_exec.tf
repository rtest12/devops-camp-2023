resource "null_resource" "execute_commands" {
  for_each = { for idx, ec2_instance in module.ec2_instances : idx => ec2_instance }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.cwd}/assets/private_keys/wordpress_cluster.pem")
      host        = each.value.public_ip
    }

    inline = [
      "echo 'Hello, Camp!'"
    ]
  }
}
