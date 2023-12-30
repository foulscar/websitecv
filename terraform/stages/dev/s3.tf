// ---
// Get Account ID
// ---
locals {
    account_id = data.aws_caller_identity.current.account_id
}

// ---
// Create an S3 Bucket Blocking Public Access
// ---
module "s3_bucket" {
  source      = "../../modules/aws/s3/buckets/private/v1"
  bucket_name = "${var.stage}-websitecv-webfiles-bucket-${local.account_id}"
}

// ---
// Upload Files from "./html" into the Bucket
// ---
resource "aws_s3_object" "upload_html" {
  bucket = "${var.stage}-websitecv-webfiles-bucket-${local.account_id}"

  for_each = fileset("${path.module}/html/upload/", "**/*.*")

  key = each.value
  source = "${path.module}/html/upload/${each.value}"
  content_type = each.value

}

// ---
// Give the CloudFront Distribution Access to the Private S3 Bucket with a Bucket Policy
// ---
module "s3_bucket_policy" {
  source                      = "../../modules/aws/s3/bucket_policies/allow_cloudfront_oac/v1"
  bucket_arn                  = module.s3_bucket.s3_bucket_arn
  bucket_id                   = module.s3_bucket.s3_bucket_id
  cloudfront_distribution_arn = module.cloudfront_distribution.arn
}
