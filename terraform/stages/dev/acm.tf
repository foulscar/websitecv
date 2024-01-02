// ---
// Create the ACM Certificate for SSL (Route53, CloudFront, and API Gateway)
// ---

module "acm_cert_cf" {
  source = "../../modules/aws/acm/validation/v1"

  domain_name = local.domain_string
  zone_id = aws_route53_zone.main.zone_id
}

module "acm_cert_api" {
  source = "../../modules/aws/acm/validation/v1"

  domain_name = "api.${local.domain_string}"
  zone_id = aws_route53_zone.main.zone_id
}
