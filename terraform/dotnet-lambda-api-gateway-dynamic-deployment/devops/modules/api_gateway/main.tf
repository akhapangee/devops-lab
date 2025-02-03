resource "aws_api_gateway_resource" "resources" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id = var.api_gateway.id
  parent_id   = var.api_gateway.root_resource_id
  path_part   = each.value.resource_path
}

resource "aws_api_gateway_method" "methods" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id   = var.api_gateway.id
  resource_id   = aws_api_gateway_resource.resources[each.key].id
  http_method   = each.value.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integrations" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id             = var.api_gateway.id
  resource_id             = aws_api_gateway_resource.resources[each.key].id
  http_method             = aws_api_gateway_method.methods[each.key].http_method
  integration_http_method = "POST"
  # AWS Lambda expects to be invoked with an HTTP POST method when using the AWS_PROXY integration type.
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_function_references[each.key].lambda_reference.arn}/invocations"

  depends_on = [
    aws_api_gateway_method.methods
  ]
}

resource "aws_api_gateway_method_response" "method_responses" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id         = var.api_gateway.id
  resource_id         = aws_api_gateway_resource.resources[each.key].id
  http_method         = aws_api_gateway_method.methods[each.key].http_method
  status_code         = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  depends_on = [
    aws_api_gateway_method.methods
  ]
}

resource "aws_api_gateway_integration_response" "integration_responses" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id = var.api_gateway.id
  resource_id = aws_api_gateway_resource.resources[each.key].id
  http_method = aws_api_gateway_method.methods[each.key].http_method

  status_code         = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Requested-With'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
  }
  depends_on = [
    aws_api_gateway_method.methods,
    aws_api_gateway_integration.integrations
  ]
}

# CORS Method for OPTIONS preflight
resource "aws_api_gateway_method" "options_methods" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id   = var.api_gateway.id
  resource_id   = aws_api_gateway_resource.resources[each.key].id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# CORS Integration for OPTIONS method
resource "aws_api_gateway_integration" "options_integrations" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id             = var.api_gateway.id
  resource_id             = aws_api_gateway_resource.resources[each.key].id
  http_method             = aws_api_gateway_method.options_methods[each.key].http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates       = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Define the response for the OPTIONS method
resource "aws_api_gateway_method_response" "options_method_responses" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id = var.api_gateway.id
  resource_id = aws_api_gateway_resource.resources[each.key].id
  http_method = aws_api_gateway_method.options_methods[each.key].http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
  depends_on = [
    aws_api_gateway_method.options_methods
  ]
}

# Define the integration response for the OPTIONS method
resource "aws_api_gateway_integration_response" "options_integration_responses" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  rest_api_id = var.api_gateway.id
  resource_id = aws_api_gateway_resource.resources[each.key].id
  http_method = aws_api_gateway_method.options_methods[each.key].http_method
  status_code = aws_api_gateway_method_response.options_method_responses[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Requested-With'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
  }

  depends_on = [
    aws_api_gateway_method.options_methods,
    aws_api_gateway_integration.options_integrations
  ]
}

resource "aws_lambda_permission" "login_apigw_lambda" {
  for_each = {for lambda in var.lambdas : lambda.function_name => lambda}

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.key
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway.execution_arn}/*/${aws_api_gateway_method.methods[each.key].http_method}/${aws_api_gateway_resource.resources[each.key].path_part}"
  tags          = var.tags
}

# Define the stage for the API Gateway
resource "aws_api_gateway_stage" "dev_stage" {
  depends_on    = [aws_api_gateway_deployment.deployment]
  rest_api_id   = var.api_gateway.id
  stage_name    = terraform.workspace
  deployment_id = aws_api_gateway_deployment.deployment.id
  tags          = var.tags
}

# Define the deployment for the API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.api_gateway.id
  description = "Deployment for the ${terraform.workspace} stage"
  depends_on  = [aws_api_gateway_integration.integrations, aws_api_gateway_integration.options_integrations]
  tags        = var.tags
}
