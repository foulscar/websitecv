// ---
// Create the ACM Certificate for SSL (Route53, CloudFront, and API Gateway)
// ---

resource "aws_acm_certificate" "domain_certificate_request" {
  domain_name = var.domain_name
  subject_alternative_names = ["*.{var.domain_name}"]
  validation_method = "DNS"

  tags = {
    Name : var.domain_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "domain_certificate_validation" {
  for_each = aws_route53_record.domain_validation_record
  
  certificate_arn = aws_acm_certificate.domain_certificate_request.arn
  validation_record_fqdns = [each.value.fqdn]
}
