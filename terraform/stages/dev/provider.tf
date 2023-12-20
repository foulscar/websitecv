provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project = "websitecv"
      CreatedBy = "Corbin Grossen"
      Stage = var.stage
    }
  }
}

provider "aws" {
  alias  = "replica"
  region = "us-west-1"
  default_tags {
    tags = {
      Project = "websitecv"
      CreatedBy = "Corbin Grossen"
      Stage = var.stage
    }
  }
}

terraform {
  required_version = "=1.6.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.26.0"
    }
  }
}
