// ---
// This Output uses a "depends_on" Argument to Ensure the Certificate ARN is Not Used Until it has Been Validated
// ---

output "certificate_arn" {
  value = aws_acm_certificate.domain_certificate_request.arn
  description = "ARN of the ACM Certificate"

  depends_on = [ aws_acm_certificate_validation.domain_certificate_validation ]
}

output "domain_validation_options" {
  value = aws_acm_certificate.domain_certificate_request.domain_validation_options
}
