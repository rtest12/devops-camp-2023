resource "null_resource" "execute_commands" {
  for_each = { for idx, ec2_instance in module.wordpress_ec2_instances : idx => ec2_instance }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ec2_user
      private_key = file(local_sensitive_file.ssh_private_key.filename)
      host        = each.value.public_ip
    }

    inline = [
      "echo 'Hello, Camp!'"
    ]
  }
  depends_on = [local_sensitive_file.ssh_private_key]
}
