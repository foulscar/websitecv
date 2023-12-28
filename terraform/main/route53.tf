// ---
// Create Route53 Hosted Zone for corbingrossen.me and Add Subdomains for different stages 
// ---

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "domain_validation_record" {
  zone_id = aws_route53_zone.main.zone_id
  name = aws_acm_certificate.domain_certificate_request.domain_validation_options.resource_record_name
  type = aws_acm_certificate.domain_certificate_request.domain_validation_options.resource_record_type
  records = [aws_acm_certificate.domain_certificate_request.domain_validation_options.resource_record_value]
  ttl = 300
}
