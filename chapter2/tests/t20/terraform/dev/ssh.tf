resource "tls_private_key" "wordpress_cluster" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "wordpress_cluster" {
  key_name   = var.ssh_cluster_name
  public_key = tls_private_key.wordpress_cluster.public_key_openssh
}

resource "local_sensitive_file" "ssh_private_key" {
  content              = tls_private_key.wordpress_cluster.private_key_openssh
  filename             = "${path.cwd}/assets/private_keys/${var.ssh_cluster_name}.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}
