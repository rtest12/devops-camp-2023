data "template_file" "remote_exec" {
  template = file("${path.cwd}/terraform/base/scripts/remote_exec.sh")
  vars = {
    name      = "Camp"
    checkfile = "/tmp/checkfile"
  }
}

resource "null_resource" "execute_commands" {
  for_each = { for idx, ec2_instance in module.wordpress_ec2_instance : idx => ec2_instance }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ec2_user
      private_key = file(local_sensitive_file.private_key_file.filename)
      host        = each.value.public_ip
    }

    inline = [
      data.template_file.remote_exec.rendered
    ]
  }
  depends_on = [local_sensitive_file.private_key_file]
}
