// ---
// Create the ACM Certificate for SSL (Route53, CloudFront, and API Gateway)
// ---

module "acm_cert_cf" {
  source = "../../modules/aws/acm/request/v1"

  domain_name = local.domain_string
}

module "acm_cert_api" {
  source = "../../modules/aws/acm/request/v1"

  domain_name = "api.${local.domain_string}"
}
