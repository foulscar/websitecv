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
  plaintext_value = module.gh_oidc_repo.role.arn.role_arn
}

// ---
// Create the OpenID Connect Provider
// ---

module "gh_oidc_provider" {
  source = "github.com/philips-labs/terraform-aws-github-oidc?ref=v0.7.1//modules/provider"
}

module "gh_oidc_repo" {
  source = "github.com/philips-labs/terraform-aws-github-oidc?ref=v0.7.1"

  openid_connect_provider_arn = module.gh_oidc_provider.openid_connect_provider.arn
  repo                        = var.gh_repo_name
  role_name                   = "${var.stage}_gh_actions"

  default_conditions          = ["allow_main"]
}
