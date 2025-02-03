
output "api_gateway_url" {
  description = "Deployed API Gateway URL"
  value       = module.api_gateway.api_gateway_url
}

output "api_gateway_resource_paths" {
  description = "The resource paths created in the API Gateway for each Lambda function"
  value = module.api_gateway.api_gateway_resource_paths
}

