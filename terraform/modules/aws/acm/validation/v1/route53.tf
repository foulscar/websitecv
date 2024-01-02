resource "aws_route53_record" "domain_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.domain_certificate_request.domain_validation_options: dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  zone_id = var.zone_id
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  ttl = var.ttl
  allow_overwrite = true
}
