// ---
// Create Route53 Hosted Zone for corbingrossen.me and Add Subdomains for different stages
// ---

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "domain_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.domain_certificate_request.domain_validation_options: dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  zone_id = aws_route53_zone.main.zone_id
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  ttl = 60
  allow_overwrite = true
}

// ---
// Dev
// ---

resource "aws_route53_record" "dev_subdomain" {
  allow_overwrite = true
  name = "dev.${var.domain_name}"
  ttl = 172800
  type = "NS"
  zone_id = aws_route53_zone.main.zone_id

  records = module.stage_dev.subdomain_ns
}
