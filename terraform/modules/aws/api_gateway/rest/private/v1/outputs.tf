output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "api_arn" {
    value = aws_api_gateway_rest_api.api.arn
}

output "api_execution_arn" {
    value = aws_api_gateway_rest_api.api.execution_arn
}

output "api_name" {
    value = aws_api_gateway_rest_api.api.name
}

output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}