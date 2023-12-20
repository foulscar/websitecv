output "id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}