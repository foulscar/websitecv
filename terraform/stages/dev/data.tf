data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "domain_strings" "current" {
  main = "${var.stage}.${var.domain_name}"
  all_prefix = "*.${var.stage}.${var.domain_name}"
}
