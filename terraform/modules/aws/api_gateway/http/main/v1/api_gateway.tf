locals {
  api_gateway_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.http_api.id}/*/*/*"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

// Create HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  description   = "HTTP API"
  protocol_type = "HTTP"
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  cors_configuration {
    allow_origins = ["https://${var.cors_allow_url}"]
    allow_methods = ["GET","OPTIONS","HEAD"]
    allow_headers = ["*"]
  }
}

resource "aws_apigatewayv2_domain_name" "domain_name" {
  count = var.domain_name != null ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type = var.endpoint_type
    security_policy = var.security_policy
  }
}

// Routes and Integrations
resource "aws_apigatewayv2_route" "api_route" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  api_id      = aws_apigatewayv2_api.http_api.id
  route_key   = "${each.value.http_method} /${each.value.path}"
  target     = "integrations/${aws_apigatewayv2_integration.api_integration[each.key].id}"
}

resource "aws_apigatewayv2_integration" "api_integration" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  api_id      = aws_apigatewayv2_api.http_api.id
  integration_type = each.value.type
  integration_method = "POST"  // Modify as needed
  integration_uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${each.value.lambda_arn}/invocations"
}

// Lambda Permission
resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  for_each     = { for idx, method in var.api_methods : idx => method }
  statement_id = "AllowExecutionFromAPIGateway"
  action       = "lambda:InvokeFunction"
  function_name = each.value.lambda_arn
  principal    = "apigateway.amazonaws.com"
  source_arn   = "${aws_apigatewayv2_api.http_api.execution_arn}/*/${each.value.http_method}/${each.value.path}"
}

// Stage (Deployment)
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id     = aws_apigatewayv2_api.http_api.id
  name       = var.stage_name
  auto_deploy = true
}
