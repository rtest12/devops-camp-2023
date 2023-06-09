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
  certificate_arn         = aws_acm_certificate.tf-maxim-omelchenko.arn
  validation_record_fqdns = values(aws_route53_record.tf-maxim-omelchenko)[*].fqdn
}
