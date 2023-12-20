// ---
// Create the Bucket Policy
// ---
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucket_id

  policy = jsonencode({
    Version   = "2008-10-17",
    Id        = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${var.bucket_id}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}