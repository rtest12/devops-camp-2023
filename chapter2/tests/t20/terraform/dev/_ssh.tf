# resource "tls_private_key" "cluster" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "cluster" {
#   key_name   = var.cluster_name
#   public_key = tls_private_key.cluster.public_key_openssh
# }

# resource "local_sensitive_file" "ssh_private_key" {
#   content              = tls_private_key.cluster.private_key_openssh
#   filename             = "${path.cwd}/assets/private_keys/${var.cluster_name}.pem"
#   file_permission      = "0600"
#   directory_permission = "0700"
# }
