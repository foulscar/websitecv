// ---
// Create the CloudFront Distribution with the Private S3 Bucket as the Origin
// ---
module "cloudfront_distribution" {
  source                = "../../modules/aws/cloudfront/s3_origin/v1"
  s3_bucket_arn         = module.s3_bucket.s3_bucket_arn
  s3_bucket_id          = module.s3_bucket.s3_bucket_id
  s3_bucket_domain_name = module.s3_bucket.s3_bucket_domain_name
}
