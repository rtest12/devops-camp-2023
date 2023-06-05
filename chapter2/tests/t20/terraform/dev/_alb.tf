module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 8.0"
  name               = local.labels.alb
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.target.id
  subnets            = data.aws_subnets.ec2.ids
  security_groups    = [module.alb_sg.security_group_id]
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
        my_target_one   = {
          target_id = module.ec2_instances["one"].id
          port       = 80
        }
        my_target_two   = {
          target_id = module.ec2_instances["two"].id
          port       = 80
        }
      }
    }
  ]

  # http_tcp_listeners = [
  #   {
  #     port               = 80
  #     protocol           = "HTTP"
  #     target_group_index = 0
  #   }
  # ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
      ssl_policy         = "ELBSecurityPolicy-2016-08"
      certificate_arn    = aws_acm_certificate.tf-maxim-omelchenko.arn
    }
  ]
  depends_on = [module.ec2_instances, module.alb_sg, aws_acm_certificate_validation.cert]
}

module "alb_sg" {
  source               = "terraform-aws-modules/security-group/aws"
  version              = "4.17.2"
  name                 = local.labels.alb_sg
  description          = "security group for alb"
  vpc_id               = data.aws_vpc.target.id
  ingress_cidr_blocks  = ["0.0.0.0/0"]
  ingress_rules        = ["http-80-tcp", "https-443-tcp"]
  egress_rules         = ["all-all"]
  tags                 = var.tags
}


resource "aws_acm_certificate" "tf-maxim-omelchenko" {
  domain_name       = var.site_url
  validation_method = "DNS"
  tags              = var.tags
  subject_alternative_names = [
  "www.${var.site_url}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.tf-maxim-omelchenko.arn}"
  validation_record_fqdns = [for record in aws_route53_record.tf-maxim-omelchenko : record.fqdn]
}
