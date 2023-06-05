module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_id = data.aws_route53_zone.domain.zone_id
  records = [
    {
      name      = var.subdomain_url
      type      = "A"
      alias     = {
        name    = module.alb.lb_dns_name
        zone_id = module.alb.lb_zone_id
        evaluate_target_health = true
      }
    },
  ]
}

resource "aws_route53_record" "tf-maxim-omelchenko" {
  for_each = {
    for dvo in aws_acm_certificate.tf-maxim-omelchenko.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id
}
