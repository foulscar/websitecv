// ---
// This TF File will Assume Different IAM Roles for each Stage
// ---

// Main Account
provider "aws" {
  region = var.AWS_REGION
  shared_config_files = [var.tfc_aws_dynamic_credentials.default.shared_config_file]
  default_tags {
    tags = {
      Project = "websitecv"
      CreatedBy = "Corbin Grossen"
      Stage = "main"
    }
  }
}

// Dev Account
provider "aws" {
  region = var.AWS_REGION
  alias = "DEV"
  assume_role {
    role_arn = var.ASSUME_ROLE_DEV
  }
  default_tags {
    tags = {
      Project = "websitecv"
      CreatedBy = "Corbin Grossen"
      Stage = "dev"
    }
  }
}
