// ---
// Create Route53 Dev Subdomain
// ---

resource "aws_route53_zone" "dev_main" {
  name = "dev.${var.domain_name}"
}
