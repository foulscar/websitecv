// ---
// Call All Stages as a Seperate Module with Seperate Accounts
// ---

// Dev Account
module "stage_dev" {
  source = "../stages/dev"
  providers = {
    aws.DEV = aws.DEV
  }
}
