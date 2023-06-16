resource "aws_acm_certificate" "certificate" {
  domain_name       = local.domain_name
  validation_method = var.acm_validation_method
  subject_alternative_names = [
    "www.${local.domain_name}"
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = values(aws_route53_record.acm_validation_records)[*].fqdn
}
