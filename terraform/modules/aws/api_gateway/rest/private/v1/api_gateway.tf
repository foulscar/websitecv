locals {
  api_gateway_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*/*/*"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

// Define the policy separately
locals {
  api_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "execute-api:Invoke",
        Resource = local.api_gateway_arn,
        Condition = {
          StringEquals = {
            "aws:sourceVpc" = var.source_vpc_id
          }
        }
      }
    ]
  })
}

// Create Rest API
resource "aws_api_gateway_rest_api" "api" {
  name                  = var.api_name
  description           = "Private REST API"
  endpoint_configuration {
    types = ["PRIVATE"]
    vpc_endpoint_ids = var.vpc_endpoint_ids
  }

  policy = local.api_policy


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id

  cache_cluster_enabled = var.cache.enabled
  cache_cluster_size    = var.cache.size

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_deployment.api_deployment
  ]
}

resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"

  settings {
    caching_enabled = var.cache.enabled
    cache_ttl_in_seconds = var.cache.ttl
  }
}


// ... remaining resources ...

resource "aws_api_gateway_resource" "api_resource" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = each.value.path
}

resource "aws_api_gateway_method" "api_method" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_resource[each.key].id
  http_method = each.value.http_method
  authorization = "NONE"  // or based on your method definition
  // ...
}

resource "aws_api_gateway_integration" "api_integration" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_resource[each.key].id
  http_method = aws_api_gateway_method.api_method[each.key].http_method
  integration_http_method = "POST"  // Changed to POST

  type = each.value.type
  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${each.value.lambda_arn}/invocations"

  content_handling = "CONVERT_TO_TEXT"  // Added content handling
}

resource "aws_api_gateway_method_response" "api_method_response" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  depends_on  = [aws_api_gateway_integration.api_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_resource[each.key].id
  http_method = aws_api_gateway_method.api_method[each.key].http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"  // Changed to refer to the Empty schema
  }
}

resource "aws_api_gateway_integration_response" "api_integration_response" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  depends_on  = [aws_api_gateway_integration.api_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_resource[each.key].id
  http_method = aws_api_gateway_method.api_method[each.key].http_method
  status_code = aws_api_gateway_method_response.api_method_response[each.key].status_code

  response_templates = {
    "application/json" = ""  // Assuming empty response template
  }
}

resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  for_each    = { for idx, method in var.api_methods : idx => method }
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_arn
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/${each.value.http_method}/${each.value.path}"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.api_method,
    aws_api_gateway_integration.api_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "api_deployment_final" {
  depends_on = [
    aws_api_gateway_stage.api_stage
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = var.stage_name

  lifecycle {
    create_before_destroy = true
  }
}
