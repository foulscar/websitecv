variable "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  type        = string
}

variable "price_class" {
  description = "The price class for the CloudFront distribution"
  default     = "PriceClass_100"
  type        = string
}

variable "default_root_object" {
  description = "The default root object for the CloudFront distribution"
  default     = "index.html"
  type        = string
}

variable "domain_name" {
  description = "Domain Name to Use for the CloudFront Distribution"
  type = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM Certificate to Use"
  type = string
}
