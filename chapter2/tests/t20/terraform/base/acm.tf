resource "aws_acm_certificate" "certificate" {
  domain_name       = var.site_url
  validation_method = "DNS"
  subject_alternative_names = [
    "www.${var.site_url}"
  ]

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = values(aws_route53_record.validation_records)[*].fqdn
}
