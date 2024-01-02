// ---
// Create the IAM Role for GitHub Actions to Assume
// ---

module "iam_gh_actions" {
  source = "../../modules/aws/iam/role/simple/v1"
  name = "${var.stage}_gh_actions"
  assume_role_policy = {
    policy_file = "${path.module}/iam/gh_actions/gh_actions_assume_role.json.tpl"
    attributes = {
      "account_arn" = data.aws_caller_identity.current.arn
      "repo" = "${var.gh_repo_owner}/${var.gh_repo_name}"
    }
  }
  policies = {
    "gh_actions" = {
      name = "${var.stage}_gh_actions"
      policy_file = "${path.module}/iam/gh_actions/gh_actions.json.tpl"
      attributes = {
        "bucket_arn" = module.s3_bucket.s3_bucket_arn
        "distribution_arn" = module.cloudfront_distribution.arn
      }
    }
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
