// ---
// Store Backend Files Remotely on AWS
// ---

module "tfstate-backend_example_s3-tfstate-backend" {
  source  = "binbashar/tfstate-backend/aws//examples/s3-tfstate-backend"
  version = "1.0.27"
  region = "us-east-1"
}
