// ---
// Manage GitHub Actions Secrets for the S3 CI/CD Pipeline
// ---

data "github_actions_public_key" "repo_public_key" {
  repository = var.gh_repo_name
}
