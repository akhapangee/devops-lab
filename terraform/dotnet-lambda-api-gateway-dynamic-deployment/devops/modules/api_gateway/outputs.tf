output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = "https://${var.api_gateway.id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage_name}"
}

output "api_gateway_resource_paths" {
  description = "The resource paths created in the API Gateway for each Lambda function"
  value = { for lambda in var.lambdas : lambda.function_name => aws_api_gateway_resource.resources[lambda.function_name].path_part }
}

output "api_gateway_method_arns" {
  description = "The ARNs of the methods created in the API Gateway for each Lambda function"
  value = { for lambda in var.lambdas :
    lambda.function_name => "arn:aws:apigateway:${var.aws_region}::/restapis/${var.api_gateway.id}/resources/${aws_api_gateway_resource.resources[lambda.function_name].id}/methods/${aws_api_gateway_method.methods[lambda.function_name].http_method}"
  }
}

output "api_gateway_integration_arns" {
  description = "The ARNs of the integrations created between API Gateway and the Lambda functions"
  value = { for lambda in var.lambdas : lambda.function_name => aws_api_gateway_integration.integrations[lambda.function_name].uri }
}
