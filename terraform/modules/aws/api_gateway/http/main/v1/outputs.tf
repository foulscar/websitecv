output "api_name" {
    value = aws_apigatewayv2_api.http_api.name
}

output "api_id" {
  value = aws_apigatewayv2_api.http_api.id
}


output "api_arn" {
    value = aws_apigatewayv2_api.http_api.arn
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "target_domain_name" {
  value = aws_apigatewayv2_domain_name.domain_name[0].domain_name_configuration[0].target_domain_name
}

output "hosted_zone_id" {
  value = aws_apigatewayv2_domain_name.domain_name[0].domain_name.domain_name_configuration[0].hosted_zone_id
}
