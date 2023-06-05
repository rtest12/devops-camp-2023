module "ec2_instances" {
  source                  = "terraform-aws-modules/ec2-instance/aws"
  for_each                = toset(["one", "two"])
  name                    = "${local.labels.ec2_instance}-${each.value}"
  ami                     = "ami-01107263728f3bef4"
  instance_type           = "t3.micro"
 # key_name                = aws_key_pair.cluster.key_name
  vpc_security_group_ids  = [module.ec2_sg.security_group_id]
  iam_instance_profile    = "ssm-role"
  subnet_id               = each.value == "one" ? element(data.aws_subnets.ec2.ids, 0) : element(data.aws_subnets.ec2.ids, 1)
  user_data = templatefile("${path.cwd}/terraform/dev/userdata.tpl", {
    DB_NAME            = var.rds_db_name
    DB_USER            = var.rds_db_user
    DB_PASSWORD        = random_password.db_password.result
    DB_HOST            = module.db.db_instance_endpoint
    AUTH_KEY           = random_password.auth_key.result
    SECURE_AUTH_KEY    = random_password.secure_auth_key.result
    LOGGED_IN_KEY      = random_password.logged_in_key.result
    NONCE_KEY          = random_password.nonce_key.result
    AUTH_SALT          = random_password.auth_salt.result
    SECURE_AUTH_SALT   = random_password.secure_auth_salt.result
    LOGGED_IN_SALT     = random_password.logged_in_salt.result
    NONCE_SALT         = random_password.nonce_salt.result
    SITE_URL           = var.site_url
    EFS_ID             = var.efs_id
    WORDPRESS_PASSWORD = random_password.wordpress_password.result
  })
  tags                    = var.tags
  root_block_device = [
    {
      encrypted    = true
      volume_size  = 20
      volume_type  = "gp3"
    }
  ]
  depends_on = [module.db]
}

module "ec2_sg" {
  source               = "terraform-aws-modules/security-group/aws"
  version              = "4.17.2"
  name                 = local.labels.ec2_sg
  description          = "Security group for the ec2 instances"
  vpc_id               = data.aws_vpc.target.id
  ingress_cidr_blocks  = [data.aws_vpc.target.cidr_block]
  ingress_rules         = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.rds_sg.security_group_id
      description              = "mysql from rds"
    }
  ]
  egress_rules         = ["all-all"]
  tags                 = var.tags
}
