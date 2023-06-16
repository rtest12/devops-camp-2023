resource "tls_private_key" "wordpress_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "wordpress_public_key" {
  key_name   = "wordpress"
  public_key = tls_private_key.wordpress_private_key.public_key_openssh
}

resource "local_sensitive_file" "private_key_file" {
  content              = tls_private_key.wordpress_private_key.private_key_openssh
  filename             = "${path.cwd}/assets/private_keys/wordpress.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}
