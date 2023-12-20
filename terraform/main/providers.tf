// ---
// This TF File will Assume Different IAM Roles for each Stage
// ---

provider "aws" {
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
}
