module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 8.6.1"
  name               = local.labels.alb
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.target.id
  subnets            = data.aws_subnets.wordpress.ids
  security_groups    = [module.wordpress_alb_sg.security_group_id]
  tags               = var.tags

  target_groups = [
    {
      name             = local.labels.tg
      backend_protocol = "HTTP"
      backend_port     = 80
      targets          = aws_alb_target_group_attachment.instance_attachments
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
      ssl_policy         = "ELBSecurityPolicy-2016-08"
      certificate_arn    = aws_acm_certificate.tf-maxim-omelchenko.arn
    }
  ]
  depends_on = [module.ec2_instances, module.wordpress_alb_sg, aws_acm_certificate_validation.cert]
}

resource "aws_alb_target_group" "wordpress_target_group" {
  name        = local.labels.tg
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.target.id
  target_type = "instance"
}

resource "aws_alb_target_group_attachment" "instance_attachments" {
  count            = var.ec2_instances_count
  target_group_arn = aws_alb_target_group.wordpress_target_group.arn
  target_id        = module.ec2_instances[count.index].id
  port             = 80
}
