data "aws_vpc" "target" {
  tags = var.vpc_tags
}

data "aws_subnets" "ec2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.target.id]
  }
}
