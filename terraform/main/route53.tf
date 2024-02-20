// ---
// Create Route53 Hosted Zone for corbingrossen.me and Add Subdomains for different stages
// ---

resource "aws_route53_zone" "main" {
  name = var.domain_name
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

// ---
// Prod
// ---

// CloudFront Record
resource "aws_route53_record" "cf_record" {
  zone_id = aws_route53_zone.main.zone_id
  name = var.domain_name
  type = "A"
  alias {
    name = module.stage_prod.cf_record_alias.name
    zone_id = module.stage_prod.cf_record_alias.zone_id
    evaluate_target_health = true
  }
}

// API Gateway record
resource "aws_route53_record" "api_record" {
  zone_id = aws_route53_zone.main.zone_id
  name = "api.${var.domain_name}"
  type = "A"
  alias {
    name = module.stage_prod.api_record_alias.target_domain_name
    zone_id = module.stage_prod.api_record_alias.hosted_zone_id
    evaluate_target_health = false
  }
}

// ---
// Create Route53 Records for MX/Mailing Server
// ---

module "route53_mx_records" {
  source = "../modules/aws/route53/mx_records"
 
  zone_id = aws_route53_zone.main.zone_id
  domain_name = var.domain_name
  MX_MAPPING = var.MX_MAPPING
}
