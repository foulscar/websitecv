// ---
// Manage GitHub Actions Secrets for the S3 CI/CD Pipeline
// ---

data "github_actions_public_key" "repo_public_key" {
  repository = var.gh_repo_name
}

resource "github_actions_secret" "bucket" {
  repository = var.gh_repo_name
  secret_name = "${var.stage}_html_s3_bucket"
  plaintext_value = module.s3_bucket.s3_bucket_domain_name
}

resource "github_actions_secret" "bucket_region" {
  repository = var.gh_repo_name
  secret_name = "${var.stage}_html_s3_bucket_region"
  plaintext_value = data.aws_region.current.name
}

resource "github_actions_secret" "dist_id" {
  repository = var.gh_repo_name
  secret_name = "${var.stage}_html_dist_id"
  plaintext_value = module.cloudfront_distribution.id
}

resource "github_actions_secret" "assume_role_arn" {
  repository = var.gh_repo_name
  secret_name = "${var.stage}_assume_role_arn"
  plaintext_value = module.iam_gh_actions.role_arn
}
