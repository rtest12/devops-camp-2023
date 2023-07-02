module "efs" {
  source           = "terraform-aws-modules/efs/aws"
  version          = "1.1.1"
  name             = local.labels.efs
  performance_mode = var.efs_performance_mode
  throughput_mode  = "elastic"
  mount_targets = [
    for az_index, az_name in data.aws_availability_zones.all.names : {
      subnet_id         = data.aws_subnets.wordpress.ids[az_index]
      availability_zone = az_name
    }
  ]
  attach_policy              = false
  security_group_name        = local.labels.efs_sg
  security_group_description = "EFS security group"
  security_group_vpc_id      = data.aws_vpc.target.id
  security_group_rules = {
    vpc = {
      description              = "NFS ingress from VPC private subnets"
      source_security_group_id = module.wordpress_ec2_sg.security_group_id
    }
  }
}
