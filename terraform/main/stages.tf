// ---
// Call All Stages as a Seperate Modules with Seperate Accounts/Roles
// ---

// Prod Account
module "stage_prod" {
  source = "../stages/prod"
  stage = "prod"
  domain_name = var.domain_name
  gh_repo_name = var.gh_repo_name
  gh_repo_owner = var.gh_repo_owner
  providers = {
    aws = aws.PROD
  }
}
