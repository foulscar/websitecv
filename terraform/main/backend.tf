// ---
// Use Backend Files Hosted on AWS 
// ---

module "tfstate-backend_example_s3-tfstate-backend" {
  region = var.AWS_REGION
  source  = "binbashar/tfstate-backend/aws//examples/s3-tfstate-backend"
  version = "1.0.27"
}
