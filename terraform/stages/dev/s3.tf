// ---
// Get Account ID
// ---
locals {
    account_id = data.aws_caller_identity.current.account_id
}

// ---
// Get Dynamic Variables for JavaScript
// ---
data "template_file" "js_vars" {
  template = "${file("${path.cwd}/../stages/dev/html/vars.js.tpl")}"
  vars = {
    metrics_api_url = "${module.public_api.api_endpoint}/prod/metrics"
  }
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
resource "null_resource" "upload_html" {
  depends_on = [module.s3_bucket]

  provisioner "local-exec" {
    command = "aws s3 sync ./html/upload s3://${module.s3_bucket.s3_bucket_id}/"
  }
}

resource "aws_s3_object" "js_vars_s3" {
  depends_on = [module.s3_bucket]

  bucket = "${var.stage}-websitecv-webfiles-bucket-${local.account_id}"
  key = "js/vars.js"
  content = "${data.template_file.js_vars.rendered}"
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

// ---
// Create an S3 Bucket for storing CodePipeline Artifacts
// ---
module "s3_bucket_artifacts" {
  source      = "../../modules/aws/s3/buckets/private/v1"
  bucket_name = "${var.stage}-codepipeline-artifacts-${local.account_id}"
}
