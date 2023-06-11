module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 8.0"
  name               = local.labels.alb
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.target.id
  subnets            = data.aws_subnets.wordpress.ids
  security_groups    = [module.wordpress_alb_sg.security_group_id]
  tags               = var.tags

  target_groups = [
    {
      backend_protocol = "http"
      backend_port     = 80
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
      targets = {
        for instance in module.ec2_instances[*].id :
        "my_target_${instance}" => {
          target_id = instance
          port      = 80
        }
      }
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
