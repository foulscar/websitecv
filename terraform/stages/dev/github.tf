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
