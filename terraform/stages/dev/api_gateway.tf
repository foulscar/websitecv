// ---
// Create a Private Rest API with API Gateway
// ---

module "private_api" {
  source = "../../modules/aws/api_gateway/rest/private/v1"

  api_name         = "${var.stage}-websitecv-api-private"
  stage_name       = "prod"
  source_vpc_id    = module.private_vpc.vpc_id
  vpc_endpoint_ids = [aws_vpc_endpoint.private_api_endpoint.id]

  cache = {
    enabled = true
    size    = "0.5"
    ttl     = 3600
  }

  api_methods = [
    {
      path        = "metrics"
      http_method = "GET"
      type        = "AWS"
      lambda_name = "${var.stage}_tf_websitecv_getmetrics"
      lambda_arn  = aws_lambda_function.lambda_tf_websitecv_getmetrics.arn
    }
  ]

}

// ---
// Create a Public HTTP API to be Used as a Proxt with API Gateway
// ---

module "public_api" {
  source = "../../modules/aws/api_gateway/http/main/v1"

  api_name   = "${var.stage}-websitecv-api-public"
  stage_name = "prod"

  cloudfront_url = module.cloudfront_distribution.domain

  api_methods = [
    {
      path        = "metrics"
      http_method = "GET"
      type        = "AWS_PROXY"
      lambda_name = "${var.stage}_tf_proxy_websitecv_getmetrics"
      lambda_arn  = aws_lambda_function.lambda_tf_proxy_websitecv_getmetrics.arn
    }
  ]

}
