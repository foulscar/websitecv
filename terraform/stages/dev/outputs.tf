output "cloudfront_domain" {
  description = "Domain of the CloudFront Distribution"
  value       = module.cloudfront_distribution.domain
}
