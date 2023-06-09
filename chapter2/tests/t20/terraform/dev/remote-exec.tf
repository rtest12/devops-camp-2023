resource "null_resource" "execute_commands" {
  for_each = { for idx, ec2_instance in module.ec2_instances : idx => ec2_instance }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
#      private_key = file("${path.cwd}/assets/private_keys/cluster.pem")
      private_key = aws_key_pair.wordpress_cluster.key_pair_id
      host        = each.value.public_ips
    }

    inline = [
      "echo 'Hello, Camp!'",
      "sudo yum update"
    ]
  }
}
