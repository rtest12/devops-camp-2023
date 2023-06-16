module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "8.7.0"
  name               = local.labels.alb
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.target.id
  subnets            = data.aws_subnets.wordpress.ids
  security_groups    = [module.wordpress_alb_sg.security_group_id]
  target_groups = [
    {
      backend_port     = 80
      backend_protocol = "http"
      name             = local.labels.tg
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      targets = [for i in range(length(module.wordpress_ec2_instance)) : {
        target_id = module.wordpress_ec2_instance[i].id
        port      = 80
      }]
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
      ssl_policy         = "ELBSecurityPolicy-2016-08"
      certificate_arn    = aws_acm_certificate.certificate.arn
    }
  ]
  depends_on = [
    module.wordpress_ec2_instance,
    module.wordpress_alb_sg,
    aws_acm_certificate_validation.certificate_validation
  ]
}
