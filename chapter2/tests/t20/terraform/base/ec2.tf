module "wordpress_ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "5.1.0"
  count                  = var.ec2_instances_count
  name                   = local.ec2_instances[count.index]
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.wordpress_cluster.key_name
  vpc_security_group_ids = [module.wordpress_ec2_sg.security_group_id]
  iam_instance_profile   = var.ec2_ssm_role
  subnet_id              = element(local.availability_zone_subnets, count.index)
  user_data = templatefile("${path.cwd}/terraform/dev/userdata.tpl", {
    db_name            = var.rds_db_name
    db_user            = var.rds_db_user
    db_password        = random_password.db_password.result
    db_host            = module.wordpress_mysql_rds.db_instance_endpoint
    auth_key           = random_password.auth_key.result
    secure_auth_key    = random_password.secure_auth_key.result
    logged_in_key      = random_password.logged_in_key.result
    nonce_key          = random_password.nonce_key.result
    auth_salt          = random_password.auth_salt.result
    secure_auth_salt   = random_password.secure_auth_salt.result
    logged_in_salt     = random_password.logged_in_salt.result
    nonce_salt         = random_password.nonce_salt.result
    site_url           = aws_acm_certificate.certificate.domain_name
    efs_id             = module.efs.id
    wordpress_password = random_password.wordpress_password.result
  })
  root_block_device = [
    {
      volume_size = var.ec2_volume_size
      volume_type = var.ec2_volume_type
    }
  ]
  tags       = var.tags
  depends_on = [local_sensitive_file.ssh_private_key]
}

resource "random_password" "wordpress_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "auth_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "secure_auth_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "logged_in_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "nonce_key" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "auth_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "secure_auth_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "logged_in_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}

resource "random_password" "nonce_salt" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_instance = "${var.client}-${var.environment}"
  }
}
