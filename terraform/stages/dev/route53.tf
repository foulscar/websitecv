// ---
// Create Route53 Dev Subdomain
// ---

resource "aws_route53_zone" "main" {
  name = local.domain_string
}

// ---
// CloudFront Record
// ---

resource "aws_route53_record" "cf_record" {
  zone_id = aws_route53_zone.main.zone_id
  name = local.domain_string
  type = "A"
  alias {
    name = module.cloudfront_distribution.domain
    zone_id = module.cloudfront_distribution.zone_id
    evaluate_target_health = true
  }
}

// ---
// API Gateway record
// ---

resource "aws_route53_record" "api_record" {
  zone_id = aws_route53_zone.main.zone_id
  name = "api.${local.domain_string}"
  type = "A"
  alias {
    name = module.public_api.target_domain_name
    zone_id = module.public_api.hosted_zone_id
    evaluate_target_health = true
  }
}
