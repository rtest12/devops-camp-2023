locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

data "aws_availability_zones" "available" {}

module "efs" {
  source = "terraform-aws-modules/efs/aws"
  name               = local.labels.efs
  performance_mode   = "generalPurpose"
  throughput_mode    = "elastic"
  tags               = var.tags
  # Mount targets / security group
  mount_targets              = { for k, v in zipmap(local.azs, data.aws_subnets.ec2.ids) : k => { subnet_id = v } }
  attach_policy              = false
  security_group_name = local.labels.efs_sg
  security_group_description = "EFS security group"
  security_group_vpc_id      = data.aws_vpc.target.id
  security_group_rules = {
    vpc = {
      description = "NFS ingress from VPC private subnets"
      source_security_group_id = module.ec2_sg.security_group_id
    }
  }

}
