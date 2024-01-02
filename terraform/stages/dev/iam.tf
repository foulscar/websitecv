// ---
// Create the IAM Role for GitHub Actions to Assume
// ---

module "iam_gh_actions" {
  source = "../../modules/aws/iam/policy/simple/v1"
  name = "${var.stage}_gh_actions"
  role_name = module.gh_oidc_repo.role.name
  policy_file = "${path.module}/iam/gh_actions/gh_actions.json.tpl"
  attributes = {
    "bucket_arn" = module.s3_bucket.s3_bucket_arn
    "distribution_arn" = module.cloudfront_distribution.arn
  }
}

// ---
// Create the IAM Role for the tf_websitecv_putmetrics Lambda Function
// ---

module "iam_tf_websitecv_putmetrics" {
  source  = "../../modules/aws/iam/role/simple/v1"
  service = "lambda.amazonaws.com"
  name    = "${var.stage}_tf_websitecv_putmetrics"
  policies = {
    "tf_websitecv_putmetrics" = {
      name        = "${var.stage}_tf_websitecv_putmetrics"
      policy_file = "${path.module}/iam/tf_websitecv_putmetrics.json.tpl"
      attributes = {
        "dynamodb_table_arn"      = module.dynamodb_table.table_arn
        "apigateway_resource_arn" = module.private_api.api_arn
      }
    }
  }
}

// ---
// Create the IAM Role for the tf_websitecv_getmetrics Lambda Function
// ---

module "iam_tf_websitecv_getmetrics" {
  source  = "../../modules/aws/iam/role/simple/v1"
  service = "lambda.amazonaws.com"
  name    = "${var.stage}_tf_websitecv_getmetrics"
  policies = {
    "tf_websitecv_getmetrics" = {
      name        = "${var.stage}_tf_websitecv_getmetrics"
      policy_file = "${path.module}/iam/tf_websitecv_getmetrics.json.tpl"
      attributes = {
        "dynamodb_table_arn" = module.dynamodb_table.table_arn
      }
    }
  }
}

// ---
// Create the IAM Role for the tf_proxy_websitecv_getmetrics Lambda Function
// ---

module "iam_tf_proxy_websitecv_getmetrics" {
  source  = "../../modules/aws/iam/role/simple/v1"
  service = "lambda.amazonaws.com"
  name    = "${var.stage}_tf_proxy_websitecv_getmetrics"
  policies = {
    "tf_websitecv_getmetrics" = {
      name        = "${var.stage}_tf_proxy_websitecv_getmetrics"
      policy_file = "${path.module}/iam/tf_proxy_websitecv_getmetrics.json.tpl"
      attributes = {
        "api_arn" = "${module.private_api.api_execution_arn}/*"
      }
    }
  }
}
