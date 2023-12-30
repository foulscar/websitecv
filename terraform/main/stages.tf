// ---
// Call All Stages as a Seperate Modules with Seperate Accounts/Roles
// ---

// Dev Account
module "stage_dev" {
  source = "../stages/dev"
  stage = "dev"
  domain_name = var.domain_name
  providers = {
    aws = aws.DEV
  }
}
