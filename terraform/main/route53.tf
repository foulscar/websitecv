// ---
// Create Route53 Hosted Zone for corbingrossen.me and Add Subdomains for different stages
// ---

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

// ---
// Prod
// ---

resource "aws_route53_record" "prod_domain" {
  allow_overwrite = true
  name = "cv.${var.domain_name}"
  ttl = 172800
  type = "NS"
  zone_id = aws_route53_zone.main.zone_id

  records = module.stage_prod.subdomain_ns
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
