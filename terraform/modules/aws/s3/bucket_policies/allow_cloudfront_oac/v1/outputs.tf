output "bucket_policy" {
  description = "The JSON policy applied to the S3 bucket"
  value       = aws_s3_bucket_policy.bucket_policy.policy
}