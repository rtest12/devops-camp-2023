module "ec2_instances" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  count         = var.ec2_instances_count
  name          = "${local.labels.ec2_instance}-${count.index + 1}"
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name               = aws_key_pair.wordpress_cluster.key_name
  vpc_security_group_ids = [module.wordpress_ec2_sg.security_group_id]
  iam_instance_profile   = "ssm-role"
  subnet_id              = local.availability_zone_subnets[count.index % length(local.availability_zone_subnets)]
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
    site_url           = aws_acm_certificate.tf-maxim-omelchenko.domain_name
    efs_id             = module.efs.id
    wordpress_password = random_password.wordpress_password.result
  })
  tags = var.tags
  root_block_device = [
    {
      encrypted   = true
      volume_size = var.ec2_volume_size
      volume_type = var.ec2_volume_type
    }
  ]
  depends_on = [module.wordpress_mysql_rds]
}
