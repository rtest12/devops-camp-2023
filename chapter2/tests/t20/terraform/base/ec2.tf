data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }
  owners = ["amazon"]
}

resource "random_password" "passwords_list" {
  for_each         = toset(var.password_keys)
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

module "label_ec2" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  count       = var.ec2_instances_count
  name        = var.client
  environment = var.environment
  attributes  = [var.project, "ec2", tostring(count.index)]
}

module "wordpress_ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.1.0"
  count                  = var.ec2_instances_count
  name                   = module.label_ec2[count.index].id
  ami                    = data.aws_ami.amazon_linux_latest.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.wordpress_public_key.key_name
  vpc_security_group_ids = [module.wordpress_ec2_sg.security_group_id]
  iam_instance_profile   = var.ec2_ssm_role
  subnet_id              = element(local.availability_zone_subnets, count.index)
  user_data = templatefile("${path.cwd}/terraform/dev/userdata.tpl", {
    db_name            = var.rds_db_name
    db_user            = var.rds_db_user
    site_url           = local.domain_name
    efs_id             = module.efs.id
    db_host            = module.wordpress_mysql_rds.db_instance_endpoint
    db_password        = random_password.passwords_list["db_password"].result
    auth_key           = random_password.passwords_list["auth_key"].result
    secure_auth_key    = random_password.passwords_list["secure_auth_key"].result
    logged_in_key      = random_password.passwords_list["logged_in_key"].result
    nonce_key          = random_password.passwords_list["nonce_key"].result
    auth_salt          = random_password.passwords_list["auth_salt"].result
    secure_auth_salt   = random_password.passwords_list["secure_auth_salt"].result
    logged_in_salt     = random_password.passwords_list["logged_in_salt"].result
    nonce_salt         = random_password.passwords_list["nonce_salt"].result
    wordpress_password = random_password.passwords_list["wordpress_password"].result
  })
  root_block_device = [
    {
      volume_size = var.ec2_volume_size
      volume_type = var.ec2_volume_type
    }
  ]
  depends_on = [local_sensitive_file.private_key_file]
}
